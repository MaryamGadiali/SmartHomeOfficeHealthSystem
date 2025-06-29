#ifndef GLOBALH
#define GLOBALH
#include <Arduino.h>
#include "Message.h"
#include <map>
#include <array>
#include <ESP32Time.h>
#include <WiFiManager.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
// Definition file

// Contains global variables and methods used across the codebase
extern String serverName;                                                                      // The server name to send requests to
extern QueueHandle_t messageQueue;                                                             // Queue to store messages
extern std::map<String, std::array<uint8_t, 6>> peerMap;                                       // Stores the sensor type as keys and the mac address as values
extern std::map<String, float> sensorThresholds;                                               // Stores the sensor type as keys and the threshold value as values - only for automated actuation
extern void OnDataRecv(const esp_now_recv_info_t *info, const uint8_t *incomingData, int len); // ESPNOW Callback function to handle received data
extern ESP32Time rtc;                                                                          // RTC object to handle time
extern WiFiManager wifiManager;                                                                // WiFi manager object to handle wifi setup
extern bool isUserPresent;                                                                     // Flag to indicate if the user is present
extern int redPin;                                                                             // For the RGB LED
extern int greenPin;                                                                           // For the RGB LED
extern int bluePin;                                                                            // For the RGB LED
extern int numOfActiveConnections;                                                             // Number of active connections
extern bool isSensorPause;                                                                     // Flag to indicate if the sensors are paused
extern WiFiClientSecure client;                                                                // Used for ensuring https requests
extern HTTPClient https;                                                                       // Used for forming the https requests
// extern const char* primaryKey;
// extern const char* localKey;
extern const String apiUsername;
extern const String apiPassword;
extern unsigned long heartbeatTime;
#endif