#include "WifiSetup.h"
#include <WiFiManager.h>
#include <Arduino.h>
#include <WiFi.h>
#include "Global.h"
// Implementation file

// Configures the hub to connect to the home wifi network
// If the hub has not been set up before, it will create an access point for the user to connect to
// If the hub has been set up before, it will automatically connect to the home wifi network
void WifiSetup::setUpWifiManager(){
    bool result;
    result=wifiManager.autoConnect("HubSetup", "HubPassword"); //AP credentials for the user to access the captive portal

    if(!result) {
        Serial.println("Failed to connect");
        ESP.restart();
    } 
    else {
        Serial.println("Connected");
    }
}
