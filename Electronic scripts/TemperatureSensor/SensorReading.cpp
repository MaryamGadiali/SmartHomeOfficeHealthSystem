#include "SensorReading.h"
#include "Global.h"
#include <Arduino.h>
#include "HubCommunication.h"
#include "SensorData.h"
#include <DHT11.h>
#include "LEDChanger.h"

bool SensorReading::takeTempReading(){
    if (isHubPeerAddressPopulated){
  LEDChanger::changeColour("Green");
    Serial.println("Taking temperature reading");
    float tempTotal=0;
    for (int i =0; i<3; i++){
    float temperature = 0;
    while(true){
        temperature = sensor.readTemperature();
        if (temperature != DHT11::ERROR_CHECKSUM && temperature != DHT11::ERROR_TIMEOUT) {
            break;
        } 
        else {
            Serial.println(DHT11::getErrorString(temperature));
        }
        delay(1000);
    }
    Serial.println("Temperature: ");
    Serial.println(temperature);
    tempTotal+=temperature;
    }
    float average = tempTotal/3;
    LEDChanger::changeColour("Blue");

    //Now send to hub
    String jsonMessage = SensorData(average, rtc.getLocalEpoch()).toJsonObject();
    HubCommunication::sendESPNowMessage(17, jsonMessage);
    Serial.println("Sent command 17");
    delay(1000);
    //Now check if it is above threshold
    HubCommunication::sendESPNowMessage(18, String(std::to_string(average).c_str())); //this is solely for hub threshold checking
    Serial.println("Sent command 18");
    return true;
}
else{
    return false;
}
}
