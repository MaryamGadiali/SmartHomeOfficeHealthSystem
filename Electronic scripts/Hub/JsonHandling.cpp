#include "JsonHandling.h"
#include <ArduinoJson.h>
#include "DeviceCommunication.h"
#include "Global.h"
#include <string>
#include "FileHandling.h"
#include <Arduino.h>
#include "LEDChanger.h"
#include "APICommunication.h"
#include "SetUp.h"
#include "WifiSetup.h"
// Implementation file

// Parses the json response and performs the commands sent from the application
// Takes in the json response
void JsonHandling::handleJson(String jsonResponse)
{
    JsonDocument jsonDoc;
    deserializeJson(jsonDoc, jsonResponse);

    for (JsonObject jsonObject : jsonDoc.as<JsonArray>())
    {
        int command = jsonObject["command"];
        // currently has 101 - 112

        // 101 : Turns off lamp
        // 102 : Turns on lamp
        // 103 : Setting thresholds
        // 104 : Removing a threshold
        // 105 : Adding/updating a threshold
        // 106 : Deleting a connected sensor
        //  107 : delete connected actuator
        //  108 : Restarts the esp32
        //  109 : Turns on fan
        //  110 : Turns off fan
        // 111: Adding new device
        //112: Resets wifi settings
        switch (command)
        {
        case 101: // Turns off lamp
        {
            Serial.println("Recieved command 101");
            DeviceCommunication::sendESPNowMessage(peerMap["Lamp"].data(), 14, "Switch off");
            String endpoint = serverName + "/switchActuatorState?ActuatorType=Lamp&state=Off&h="+ WiFi.macAddress();
            APICommunication::POSTRequest(endpoint, "Off command sent", 0);
            break;
        }
        case 102: // Turns on lamp
        {
            Serial.println("Recieved command 102");
            DeviceCommunication::sendESPNowMessage(peerMap["Lamp"].data(), 12, "Switch on");
            String endpoint = serverName + "/switchActuatorState?ActuatorType=Lamp&state=On&h="+ WiFi.macAddress();
            APICommunication::POSTRequest(endpoint, "On command sent", 0);
            Serial.println("Sent command 12 to lamp");
            break;
        }
        case 103: // Setting thresholds
        {
            Serial.println("Recieved command 103");
            if (jsonObject["message"] == "null")
            {
                Serial.println("Threshold message is null");
                break;
            }
            // It is receiving "message": "{sensorTypeName:sensorType, thresholdMin:intVal, actuatorTypeName:actuatorType}",

            JsonArray messageJson = jsonObject["message"].as<JsonArray>();
            for (JsonObject jsonObject2 : messageJson)
            {
                String sensorTypeName = jsonObject2["sensorTypeName"];
                Serial.println("Sensor type name: ");
                Serial.println(sensorTypeName);
                String threshold = jsonObject2["threshold"];
                Serial.println("Threshold: ");
                Serial.println(threshold);
                float thresholdFloat = std::stof(threshold.c_str());
                String actuatorTypeName = jsonObject2["actuatorTypeName"];
                Serial.println("Actuator type name: ");
                Serial.println(actuatorTypeName);
                sensorThresholds[sensorTypeName] = thresholdFloat;
                // targetActutators[sensorTypeName] = actuatorTypeName;
            }
            break;
        }

        case 104: // Removing a threshold
        {
            Serial.println("Recieved command 104");
            String sensorKey = jsonObject["message"];
            sensorThresholds.erase(sensorKey);
            // targetActutators.erase(sensorKey);
            break;
        }
        case 105: // Adding/updating a threshold
        {
            Serial.println("Recieved command 105");
            JsonObject messageJson = jsonObject["message"].as<JsonObject>();
            String sensorTypeName = messageJson["sensorTypeName"];
            Serial.println(sensorTypeName);
            String threshold = messageJson["threshold"];
            Serial.println(threshold);
            float thresholdFloat = std::stof(threshold.c_str());
            String actuatorTypeName = messageJson["actuatorTypeName"];
            Serial.println(actuatorTypeName);
            sensorThresholds[sensorTypeName] = thresholdFloat;
            // targetActutators[sensorTypeName] = actuatorTypeName;
            break;
        }
        case 106: // Deleting sensor from file and peerMap
        {
            Serial.println("Received command 106 to delete sensor");
            String sensorKey = jsonObject["message"];
            FileHandling::addExistingPeersToEspNowCommunication();

            Serial.println("Peer map size: ");
            Serial.println(peerMap.size());
            DeviceCommunication::sendESPNowMessage(peerMap[sensorKey].data(), 19, "Factory reset");
            sensorThresholds.erase(sensorKey);
            // targetActutators.erase(sensorKey);
            peerMap.erase(sensorKey);
            if(sensorKey=="Occupancy"){
              FileHandling::deleteFile();
            }
            else{
              FileHandling::deleteSpecificLine(sensorKey);
            }
            break;
        }
        case 107: // Deletes Actuator
        {
            Serial.println("Received command 107 to delete actuator");
            String actuatorKey = jsonObject["message"];
            FileHandling::addExistingPeersToEspNowCommunication();
            DeviceCommunication::sendESPNowMessage(peerMap[actuatorKey].data(), 19, "Factory reset");
            peerMap.erase(actuatorKey);
            FileHandling::deleteSpecificLine(actuatorKey);
            break;
        }
        case 108: // Restarts the esp32
        {
            Serial.println("Received command 108 to restart esp32 ");
            ESP.restart();
            break;
        }
        case 109: // Turns on fan
        {
            Serial.println("Received Command 109");
            DeviceCommunication::sendESPNowMessage(peerMap["Fan"].data(), 12, "Switch on");
            String endpoint = serverName + "/switchActuatorState?ActuatorType=Fan&state=On&h="+ WiFi.macAddress();
            APICommunication::POSTRequest(endpoint, "On command sent", 0);
            break;
        }
        case 110: // Turns off fan
        {
            Serial.println("Received Command 110");
            DeviceCommunication::sendESPNowMessage(peerMap["Fan"].data(), 14, "Switch off");
            String endpoint = serverName + "/switchActuatorState?ActuatorType=Fan&state=Off&h="+ WiFi.macAddress();
            APICommunication::POSTRequest(endpoint, "Off command sent", 0);
            break;
        }
        case 111: // Starts adding new device process
        {
            Serial.println("Received Command 111");
            delay(1000);
            LEDChanger::changeColour("Pink");
            delay(5000);
            // Broadcast message to all sensors to stop messaging
            DeviceCommunication::sendESPNowBroadcastMessage(21, "Pause");
            isSensorPause = true;
            SetUp::addNewDeviceToNetwork();
            APICommunication::GETRequest(serverName + "/getThresholds?hubMacAddress=" + WiFi.macAddress() + "&isStartUp=False", 0);
            delay(1000);
            DeviceCommunication::sendESPNowBroadcastMessage(7, (static_cast<String>(rtc.getLocalEpoch())));
            delay(1000);
            DeviceCommunication::sendESPNowBroadcastMessage(22, "Wake up");
            isSensorPause = false;
            heartbeatTime = millis();
            break;
        }
        case 112:{ //Resets wifi settings
          Serial.println("Received Command 112");
          wifiManager.resetSettings();
          LEDChanger::changeColour("Red");
          WifiSetup::setUpWifiManager();
          LEDChanger::changeColour("Blue");
          FileHandling::addExistingPeersToEspNowCommunication();
          break;
        }
        default:
            Serial.println("Invalid command");
            Serial.println(command);
            break;
        }
    }
}