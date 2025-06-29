#include "Global.h"
#include "freertos/queue.h"
#include "Message.h"
// Implementation file

//Queue to store messages
QueueHandle_t messageQueue = xQueueCreate(100, sizeof(Message));

//Peer address of the hub
uint8_t hubPeerAddress[6];
bool isHubPeerAddressPopulated=false;

//RTC object to handle time
ESP32Time rtc(0);

//Hub activeness check
unsigned long lastReceivedTime;
unsigned long timeoutInterval = 360000; // If it hasn't received a message in 6 mins, it resets to adjust channel

// ESPNow Callback function to handle received messages
void OnDataRecv(const esp_now_recv_info_t *info, const uint8_t *incomingData, int len)
{
  Message receivedMessage;
  memcpy(&receivedMessage, incomingData, sizeof(receivedMessage));
  if (receivedMessage.command == 7)
  {
    rtc.setTime(atoll((receivedMessage.data)));
  }
  else
  {
    Serial.print("Command: ");
    Serial.println(receivedMessage.command);
    memcpy(receivedMessage.srcAddr, info->src_addr, sizeof(receivedMessage.srcAddr));
    xQueueSendFromISR(messageQueue, &receivedMessage, NULL);
  }
  lastReceivedTime = millis();
}
// extern const char* primaryKey= "wo4jVlgtYLmL9aal";
// extern const char* localKey= "VBt7yCjKbAvQ2K5z";

//Sensor specific
BH1750 bh1750Sensor;
const int sdaPin = 25;
const int sclPin = 33;
const int redPin = 27;
const int greenPin = 26;
const int bluePin = 32;
