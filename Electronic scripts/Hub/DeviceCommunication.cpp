#include "DeviceCommunication.h"
#include "APICommunication.h"
#include <WiFiClientSecure.h>
#include "Global.h"
#include "Message.h"
#include <string.h>
#include "FileHandling.h"
#include <esp_wifi.h>
#include <string>
#include <set>
#include "LEDChanger.h"
// Implementation file - commented out lines are the encryption implementation

// Broadcasts as a WIFI AP point for the devices to be set on the correct channel
// Take in the number of sensors that need to be connected, a timeout boolean and a time period
// If the timeout is true, the method will run for the time period
// If the timeout is false, the method will run until the number of sensors connected is equal to the number of sensors that need to be connected
void DeviceCommunication::configureWifiChannel(int numOfSensors, bool timeout, int timePeriod)
{
  LEDChanger::changeColour("Orange");
  WiFi.mode(WIFI_AP_STA);
  WiFi.softAP("ESP32Hub", "as45huibFA9");
  unsigned long startTime = millis();

  if (timeout)
  {
    Serial.println("Broadcasting AP...");
    while ((millis() - startTime) < timePeriod)
    {
      if (WiFi.softAPgetStationNum() == numOfSensors) // If all devices are connected at once it ends the loop to save time
      {
        break;
      }
      // delay(500);
    }
  }
  else
  {
    while (true)
    { // needs to deal with the case where the person switches on the sensor and actuator at the same time...
      if (WiFi.softAPgetStationNum() == numOfSensors)
      { // quicker if everyone joins at start
        break;
      }
    }
  }
  delay(10000);                // Sensor needs time to establish connection
  WiFi.softAPdisconnect(true); // Disconnects the AP
  LEDChanger::changeColour("Blue");
}

// This is used for new devices to be added to the peer list in the file and to send the initalisation command to the device
// Takes in the device mac address in hex format and the sensor type
bool DeviceCommunication::addDeviceToPeerList(String deviceMacAddress, String sensorType)
{
  esp_now_init();
  esp_now_register_recv_cb(OnDataRecv);
  // esp_err_t result = esp_now_set_pmk((uint8_t *)primaryKey);
  // Serial.println(esp_err_to_name(result));

  esp_now_peer_info_t peerInfo={};
  // memset(&peerInfo, 0, sizeof(peerInfo));
  // memcpy(peerInfo.lmk,localKey,16);
  uint8_t macAddressBytes[6];
  // Reads the hex mac address from the string by converting it to bytes - one byte per hex pair
  std::sscanf(deviceMacAddress.c_str(), "%02x:%02x:%02x:%02x:%02x:%02x", &macAddressBytes[0], &macAddressBytes[1], &macAddressBytes[2], &macAddressBytes[3], &macAddressBytes[4], &macAddressBytes[5]);

  memcpy(peerInfo.peer_addr, macAddressBytes, 6);
  // peerInfo.encrypt = true;
  esp_now_add_peer(&peerInfo);
  FileHandling::writeNewSensorToFile(peerInfo, sensorType);

  delay(5000); //Sometimes the command 1 was missed, need time for the nodes to initiate esp now

  Serial.println("Sending command 1");

  //print the mac bytes
  for (int i = 0; i < 6; i++)
  {
    Serial.print(peerInfo.peer_addr[i], HEX);
    Serial.print(":");
  }
  Serial.println();
  // Message Message;
  // Message.command = 1;
  // strncpy(Message.data, WiFi.macAddress().c_str(), sizeof(Message.data));
  // esp_now_send(peerInfo.peer_addr, (uint8_t *)&Message, sizeof(Message));
  sendESPNowMessage(peerInfo.peer_addr, 1, WiFi.macAddress());
  delay(3000);
  return true;
}

// Sends a ESPNOW message to a specific device
// Takes in the peer address, the command and the message
bool DeviceCommunication::sendESPNowMessage(uint8_t *peerAddress, int command, String message)
{ 
  Message Message;
  Message.command = command;
  strncpy(Message.data, message.c_str(), sizeof(Message.data));
  esp_now_peer_info_t peerInfo={};

  if(esp_now_get_peer(peerAddress, &peerInfo)!=ESP_OK){
    // memset(&peerInfo, 0, sizeof(peerInfo));
    // memcpy(peerInfo.lmk,localKey,16);
    memcpy(peerInfo.peer_addr, peerAddress, 6);
    // peerInfo.encrypt = true;
    esp_now_add_peer(&peerInfo);
  }
  // memcpy(peerInfo.peer_addr, peerAddress, 6);
  // memcpy(peerInfo.lmk,LMK_KEY_STR,sizeof(LMK_KEY_STR));
  // peerInfo.encrypt = true;

  while (true)
  {
    esp_err_t result = esp_now_send(peerInfo.peer_addr, (uint8_t *)&Message, sizeof(Message));
    if (result != ESP_OK)
    {
      Serial.print("Failed to send message. Error: ");
      Serial.println(esp_err_to_name(result));
      if (result==ESP_ERR_ESPNOW_NOT_INIT){
        esp_now_init();
        esp_now_peer_info_t peerInfo={};
        // memset(&peerInfo, 0, sizeof(peerInfo));
        // memcpy(peerInfo.lmk,localKey,16);
        memcpy(peerInfo.peer_addr, peerAddress, 6);
        // peerInfo.encrypt = true;
        esp_now_add_peer(&peerInfo);
      }
      delay(1000);
    }
    else
    {
      Serial.println("Successfully sent message: ");
      Serial.println(command);
      break;
    }
  }
  return true;
}

// Sends a ESPNOW broadcast message to all devices
// Takes in the command and the message
bool DeviceCommunication::sendESPNowBroadcastMessage(int command, String message)
{
  Message Message;
  Message.command = command;
  strncpy(Message.data, message.c_str(), sizeof(Message.data));
  esp_now_peer_info_t peerInfo = {};
  uint8_t broadcastAddress[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  // peerInfo.encrypt = false; 
  
  esp_now_add_peer(&peerInfo);
  esp_err_t result = esp_now_send(peerInfo.peer_addr, (uint8_t *)&Message, sizeof(Message));
  if (result != ESP_OK)
  {
    Serial.print("Failed to send message. Error: ");
    Serial.println(esp_err_to_name(result));
    return false;
  }
  else
  {
    return true;
  }
}
