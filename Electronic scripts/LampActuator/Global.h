#ifndef GLOBALH
#define GLOBALH
#include <Arduino.h> //For String
#include "Message.h"
#include <ESP32Time.h>
// Definition file

// Contains global variables and methods used across the codebase
extern QueueHandle_t messageQueue; 
extern uint8_t hubPeerAddress[6];
extern bool isHubPeerAddressPopulated; 
extern void OnDataRecv(const esp_now_recv_info_t *info, const uint8_t *incomingData, int len);
extern ESP32Time rtc;
// extern const char* primaryKey;
// extern const char* localKey;

 //Hub activeness check
extern unsigned long lastReceivedTime;
extern unsigned long timeoutInterval; // If it hasn't received a message in 6 mins, it resets to adjust channel

//Actuator specific
extern const int relayPin;
extern const int redPin;
extern const int greenPin;
extern const int bluePin;
#endif