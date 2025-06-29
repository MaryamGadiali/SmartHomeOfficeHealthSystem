#include "Global.h"
#include "freertos/queue.h"
// Implementation file

String serverName = "https://192.168.183.202:8443"; // Mobile data

// Queue to store messages
QueueHandle_t messageQueue = xQueueCreate(200, sizeof(Message));

// Map to store the sensor type as keys and the mac address as values
std::map<String, std::array<uint8_t, 6>> peerMap;

// Map to store the sensor type as keys and the threshold value as values - only for automated actuation
std::map<String, float> sensorThresholds;

// ESPNow Callback function to handle received data
void OnDataRecv(const esp_now_recv_info_t *info, const uint8_t *incomingData, int len)
{ //Only Message objects are passed through
  Message receivedMessage;
  memcpy(&receivedMessage, incomingData, sizeof(receivedMessage));
  Serial.print("Command: ");
  Serial.println(receivedMessage.command);
  memcpy(receivedMessage.srcAddr, info->src_addr, sizeof(receivedMessage.srcAddr));
  if (receivedMessage.command==4 || receivedMessage.command==3 || receivedMessage.command==2){
    xQueueSendToFrontFromISR(messageQueue, &receivedMessage, NULL);
  }
  else{
    xQueueSendFromISR(messageQueue, &receivedMessage, NULL);
  }
}

// RTC object to handle time
ESP32Time rtc(0);

// WiFi manager object to handle wifi setup
WiFiManager wifiManager;

// Flag to indicate if the user is present
bool isUserPresent = true;

// For the RGB LED
int redPin = 18;
int greenPin = 19;
int bluePin = 21;

// Number of active connections
int numOfActiveConnections = 0;

// Flag to indicate if the sensors are paused
bool isSensorPause = false;

// Used for ensuring https requests
WiFiClientSecure client;

// Used for forming the https requests
HTTPClient https;

// const char* primaryKey= "wo4jVlgtYLmL9aal";
// const char* localKey= "VBt7yCjKbAvQ2K5z";

const String apiUsername="hubAccount";
const String apiPassword="8dOB3evsKDUxBIcEel5eQ8Qli4hSlj07";

unsigned long heartbeatTime;



