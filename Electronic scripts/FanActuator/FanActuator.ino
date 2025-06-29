#include <WiFi.h>
#include <esp_now.h>
#include "Message.h"
#include <esp_wifi.h>
#include "HubCommunication.h"
#include <LittleFS.h>
#include <FileHandling.h>
#include "Global.h"

//State durations
unsigned long lastSendTime;
unsigned long sendInterval = 60000; //1 minute

void setup()
{
  Serial.begin(115200);
  delay(1000);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  WiFi.mode(WIFI_STA);
  FileHandling::setUp();
  HubCommunication::configureChannel();
  esp_now_init();
  esp_now_register_recv_cb(OnDataRecv);
  // esp_now_set_pmk((uint8_t *)primaryKey);
  FileHandling::addExistingHubToEspNowCommunication();

  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, HIGH); // Turns off when starting

  HubCommunication::sendESPNowMessage(27, "Off");
  lastSendTime = millis();
  lastReceivedTime = millis();
}

void loop()
{

  //Runtime debug commands
  if (Serial.available() > 0)
  {                                                // Check if data is available
    String command = Serial.readStringUntil('\n'); // Read the message
    command.trim();                                // Remove any trailing spaces or newline characters
    Serial.println("Command is: " + command);
    if (command == "1")
    {
      lastSendTime=0;
    }
    else if (command=="2"){
      FileHandling::deleteFile();
    }
    else{
      Serial.println("Invalid command");
    }
  }
  
  if (millis() - lastSendTime > sendInterval)
    {
        String state;
        if (digitalRead(relayPin)){
          state="Off";
        }
        else{
          state="On";
        }
        HubCommunication::sendESPNowMessage(27, state);
        Serial.println("Sent command 27");
        lastSendTime = millis();
    }

  if ((millis() - lastReceivedTime) > timeoutInterval)
  {
    Serial.println("Hub has not sent message in 6 minutes");
    ESP.restart();
  }

  Message message;
  if (xQueueReceive(messageQueue, &message, 0))
  {
    int command = message.command;

    switch (command)
    {
    case 1: // Initialisation command
    {
      Serial.println("Received Command 1");
      esp_now_peer_info_t peerInfo = {};
      // memcpy(peerInfo.lmk,localKey,16);
      memcpy(peerInfo.peer_addr, message.srcAddr, 6);
      // peerInfo.encrypt = true;
      memcpy(hubPeerAddress, peerInfo.peer_addr, sizeof(peerInfo.peer_addr));
      isHubPeerAddressPopulated=true;
      esp_now_add_peer(&peerInfo);
      FileHandling::writeNewHubToFile(peerInfo.peer_addr);

      // delay(5000);
      HubCommunication::sendESPNowMessage(4, WiFi.macAddress());
      break;
    }
    case 12: // Turns on fan
    {
      Serial.println("Received Command 12");
      if (digitalRead(relayPin))
      {
        digitalWrite(relayPin, LOW);
      }
      break;
    }
    case 14: // Turns off fan
    {
      Serial.println("Received Command 14");
      if (!digitalRead(relayPin))
      {
        digitalWrite(relayPin, HIGH);
      }
      break;
    }
    case 19: // Factory reset
    {
      Serial.println("Received command 19");
      FileHandling::deleteFile();
      digitalWrite(relayPin, HIGH); // Turns off fan
      ESP.restart();
      break;
    }
    case 20: // Pause commands for sensors, not affecting actuators
    case 21:
    case 22:
    {
      Serial.println("Received Command 20,21,22 - ignore");
      break;
    }
    case 23: // Heartbeat command
    {
      Serial.println("Received Command 23");
      HubCommunication::sendESPNowMessage(24, "Present");
      break;
    }
    default:
    {
      Serial.println("Invalid command");
      Serial.println(command);
      Serial.println("Data is: ");
      Serial.println(message.data);
      break;
    }
    }
  }
  else
  {
    // Serial.print(".");
  }
  // delay(1000);
}
