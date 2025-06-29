#include "SensorReading.h"
#include "Global.h"
#include <Arduino.h>
#include "HubCommunication.h"
#include "SensorData.h"
#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"
#include <vector>

/*
  Adapted from 
  "Optical Heart Rate Detection (PBA Algorithm) using the MAX30105 Breakout
  By: Nathan Seidle @ SparkFun Electronics
  Date: October 2nd, 2016
  https://github.com/sparkfun/SparkFun_MAX3010x_Sensor_Library
  Show the reading of heart rate or beats per minute (BPM) using
  a Penpheral Beat Amplitude (PBA) algorithm. 
  "

*/
bool SensorReading::takeHeartRateReading() {
  if (isHubPeerAddressPopulated) {
    std::vector<int> heartReadings;
    long lastBeat = 0;  //Time at which the last beat occurred
    float beatsPerMinute;
    int beatAvg;

    // Initialize sensor
    if (!heartSensor.begin(Wire, I2C_SPEED_FAST))  //400kHz speed (against the standard 100kHz)
    {
      Serial.println("MAX30105 was not found. Please check wiring/power. ");
      return false;
    }
    heartSensor.setup();
    heartSensor.setPulseAmplitudeRed(0x0A);  //Turns on

    unsigned long startTime = millis();

    while (true) {
      if ((millis() - startTime) > 30000) {  //Takes readings for 30 seconds
        break;
      }
      long irValue = heartSensor.getIR();
      if (checkForBeat(irValue) == true) { //Beat detected
        long delta = millis() - lastBeat;
        lastBeat = millis();

        beatsPerMinute = 60 / (delta / 1000.0);
        Serial.println(beatsPerMinute);
        if (beatsPerMinute < 255 && beatsPerMinute > 30) {
          heartReadings.push_back(beatsPerMinute);
        }
      } else if (irValue < 50000) {
        Serial.print("No finger detected");
      }
    }
    Serial.println("Finished reading");

    //Takes out outliers using IQR, not z score
    //Orders the vector 
    if (heartReadings.size() > 0) {
      std::sort(heartReadings.begin(), heartReadings.end());
      Serial.println("Vector sorted: ");
      for (int i = 0; i < heartReadings.size(); i++) {
        Serial.println(heartReadings[i]);
      }

      //Finds the median
      int median = 0;
      int medianIndex = 0;
      int medianRemainder = heartReadings.size() % 2;
      if (medianRemainder == 0) {
        medianIndex = (heartReadings.size() / 2);
        median = heartReadings[(heartReadings.size() / 2)];
      } else {
        medianIndex = (heartReadings.size() / 2) + 1;
        median = heartReadings[(heartReadings.size() / 2) + 1];
      }

      //Cuts anything lower than 25% or higher than 75% using IQR
      int q1Pos = medianIndex / 2;
      int q3Pos = q1Pos * 3;
      int total = 0;
      int amount = 0;

      for (int i = q1Pos; i <= q3Pos; i++) {
        total += heartReadings.at(i);
        amount++;
      }
      double average = (double)total / (double)amount;
      Serial.println("Final average heart beat is: ");
      Serial.println(average);

      if (average < 45) {
        Serial.println("Heart reading is too low, not submitting");
        return false;
      }
      heartSensor.setPulseAmplitudeRed(0);  //Turns off

      //Create the json reading message;
      String jsonMessage = SensorData(average, rtc.getLocalEpoch()).toJsonObject();

      HubCommunication::sendESPNowMessage(25, jsonMessage);  //Goes to the server
      return true;
    }

    else {
      Serial.println("No heart readings taken");
      heartSensor.setPulseAmplitudeRed(0);  //Turns off
      return false;
    }
  } else {
    return false;
  }
}