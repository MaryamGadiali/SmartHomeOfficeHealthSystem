#include "esp_err.h"
#include "HubCommunication.h"
#include <WiFi.h>
#include <esp_wifi.h>
#include "Global.h"
// Implementation file

// The SSID and password of the hub's Access Point
const char *hubSSID = "ESP32Hub";
const char *hubPassword = "as45huibFA9";

// Gets the channel of the hub's Access Point out of 12 channels
// Returns the channel number
int getWiFiChannel()
{
  // Scans for networks until the hub's Access Point is found and then connects to it
  while (true)
  {
    if (int n = WiFi.scanNetworks())
    {
      for (int i = 0; i < n; i++)
      {
        Serial.println(WiFi.SSID(i));
        if (WiFi.SSID(i) == "ESP32Hub")
        {
          Serial.println("Found channel, now going to connect to HUB AP");
          WiFi.begin(hubSSID, hubPassword);
          while (WiFi.status() != WL_CONNECTED)
          {
            Serial.println("Connecting to hub AP...");
            delay(500);
          }

          delay(1000);
          WiFi.disconnect();

          Serial.println("Leaving getWiFiChannel");

          return WiFi.channel(i);
        }
      }
    }
    Serial.println("Did not find hub AP in this iteration of networks");
    delay(5000);
  }
  return 0;
}

// Configures the channel of the ESP32 to the channel of the hub's Access Point
void HubCommunication::configureChannel()
{
  int channel = getWiFiChannel();
  // delay(5000);

  esp_wifi_set_promiscuous(true);
  esp_wifi_set_channel(channel, WIFI_SECOND_CHAN_NONE);
  esp_wifi_set_promiscuous(false);

  Serial.println("Finishing adjusting the channel");
}

// Sends a message to the hub
// Takes in the command and message to send
bool HubCommunication::sendESPNowMessage(int command, String message)
{
  if (isHubPeerAddressPopulated){
  Message Message;
  Message.command = command;
  strncpy(Message.data, message.c_str(), sizeof(Message.data));

  esp_now_peer_info_t peerInfo;
  //Get the hub's peer
  if(esp_now_get_peer(hubPeerAddress, &peerInfo)!=ESP_OK){
    // memcpy(peerInfo.lmk,localKey,16);
    memcpy(peerInfo.peer_addr, hubPeerAddress, 6);
    // peerInfo.encrypt = true;
    esp_now_add_peer(&peerInfo);
  }


  while (true)
  {
    Serial.println("Sending command:");
    Serial.println(command);
    if (esp_now_send(peerInfo.peer_addr, (uint8_t *)&Message, sizeof(Message)) != ESP_OK)
    {
      Serial.println("Failed to send message to hub");
      delay(1000);
    }
    else
    {
      break;
    }
  }

  return true;
  }
  return false;
}