#include "InternalClock.h"
#include <ESP32Time.h>
#include "APICommunication.h"
#include "Global.h"
#include <string>
// Implementation file

// Connects to the web api to get the current time to set the internal clock to
void InternalClock::configureInternalClock()
{
  String response = "Timeout";
  // Cannot proceed without the correct time
  while (response == "Timeout")
  {
    response = APICommunication::GETRequestDirect(serverName + "/syncTime", 0);
  }
  long long epochTime = atoll(response.c_str()) / 1000; // Response is in milliseconds
  rtc.setTime(epochTime);                               // internal clock is set here in seconds
  Serial.println("Internal clock has been set");
}