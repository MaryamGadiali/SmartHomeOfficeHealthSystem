#ifndef DeviceCommunicationH
#define DeviceCommunicationH
#include <HTTPClient.h>
#include <WiFi.h>
#include <esp_now.h>
// Definition file

// Contains methods used to handle the devices
class DeviceCommunication
{

public:
  static bool addDeviceToPeerList(String deviceMacAddress, String sensorType);                     // Adds a new device to the peer list and file
  static void configureWifiChannel(int numOfSensors, bool timeout = true, int timePeriod = 30000); // Broadcasts as a WIFI AP point for the devices to be set on the correct channel
  static bool sendESPNowMessage(uint8_t *peerAddress, int command, String message);                // Sends a ESPNOW message to a specific device
  static bool sendESPNowBroadcastMessage(int command, String message);                             // Broadcasts a ESPNOW message to all devices
};

#endif