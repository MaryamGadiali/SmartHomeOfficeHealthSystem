#include "SensorReading.h"
#include "Global.h"
#include <Arduino.h>
#include <BH1750.h>
#include "HubCommunication.h"
#include "SensorData.h"
#include "LEDChanger.h"

bool SensorReading::takeLightReading(){
  if (isHubPeerAddressPopulated){


  LEDChanger::changeColour("Green");
  float totalReading = 0;
    for (int i =0; i<3; i++){

  while (!(bh1750Sensor.begin(BH1750::ONE_TIME_HIGH_RES_MODE))){
      Serial.println("Looping bh1750");
      delay(1000);
    }
    
      float luxReading = -1;
      while (luxReading<0.1){
        if (bh1750Sensor.measurementReady(true)) { 
        luxReading = bh1750Sensor.readLightLevel();
            Serial.print("Light: ");
          Serial.print(luxReading);
          Serial.println(" lx");
        }
          delay(1000);
      }
      totalReading+=luxReading;
      delay(1000);
    }
    float finalReading = totalReading/(float)3;
    LEDChanger::changeColour("Blue");

//create the json object
    String jsonMessage = SensorData(finalReading, rtc.getLocalEpoch()).toJsonObject();
  //should call the esp now message - command 5 here for the hub
    HubCommunication::sendESPNowMessage(5, jsonMessage); //this goes straight to the server
    Serial.println("Sent command 5");
    delay(1000);
    HubCommunication::sendESPNowMessage(11, String(std::to_string(finalReading).c_str())); //this is solely for hub threshold checking
  Serial.println("Sent command 11");
  return true;
  }
  else{
    return false;
  }
}