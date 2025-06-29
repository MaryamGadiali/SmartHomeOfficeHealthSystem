#include <WiFi.h>
#include <esp_now.h>
#include "Message.h"
#include <esp_wifi.h>
#include "HubCommunication.h"
#include <LittleFS.h>
#include <FileHandling.h>
#include "Global.h"
#include <ESP32Time.h>
#include "SensorReading.h"
#include "SensorData.h"
#include "LEDChanger.h"

// Reading durations
unsigned long lastSendTime;
unsigned long sendInterval = 300000; //5 minutes

void setup()
{
  Serial.begin(115200);
  delay(1000);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  LEDChanger::changeColour("Blue");
  WiFi.mode(WIFI_STA);
  FileHandling::setUp();
  HubCommunication::configureChannel();
  esp_now_init();
  esp_now_register_recv_cb(OnDataRecv);
  // esp_now_set_pmk((uint8_t *)primaryKey);
  FileHandling::addExistingHubToEspNowCommunication();

  LEDChanger::changeColour("Purple");
  while (rtc.getLocalEpoch() < 10000000)
  {
    Serial.println("Local epoch time is not set, waiting for command 7");
    delay(1000);
  }
  LEDChanger::changeColour("Blue");

  SensorReading::takeTempReading();
  lastSendTime = millis();
  lastReceivedTime = millis();
}

void loop()
{
  //Runtime debug commands
  if (Serial.available() > 0) {                     // Check if data is available
    String command = Serial.readStringUntil('\n');  // Read the message
    command.trim();                                 // Remove any trailing spaces or newline characters
    Serial.println("Command is: " + command);
    if (command == "1") {
      SensorReading::takeTempReading();
      lastSendTime = millis();
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
    bool result = SensorReading::takeTempReading();
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
    case 1: // Initalisation command
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
      HubCommunication::sendESPNowMessage(3, WiFi.macAddress());
      break;
    }
    case 19: // Factory reset
    {
      Serial.println("Received command 19");
      FileHandling::deleteFile();
      ESP.restart();
      break;
    }

    case 20: // Pause
    case 21:
    {
      Serial.println("Received Command 20/21 - pause");
      LEDChanger::changeColour("Red");
      int queueSize = uxQueueMessagesWaiting(messageQueue);
      while (uxQueueMessagesWaiting(messageQueue) == queueSize)
      {
        Serial.println(uxQueueMessagesWaiting(messageQueue));
        Serial.println(queueSize);
        delay(5000);
      }
      Serial.println("Received wakeup command");
      LEDChanger::changeColour("Blue");
      break;
    }
    case 22: // Wake up
    {
      Serial.println("Received Command 22 to indicate wake up");
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
      Serial.println("Command is");
      Serial.println(message.command);
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
