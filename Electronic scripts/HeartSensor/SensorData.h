#ifndef SensorDataH
#define SensorDataH
#include <ArduinoJson.h>
#include <Arduino.h>
// Class to store sensor data and convert it to a JSON object
class SensorData
{
public:
    float value;
    unsigned long epochSeconds;

    // Constructor
    SensorData(float value, unsigned long epochSeconds)
    {
        this->value = value;
        this->epochSeconds = epochSeconds;
    }

    // Method to convert the sensor data to a JSON object
    String toJsonObject()
    {
        JsonDocument jsonString;
        jsonString["reading"] = this->value;
        jsonString["timestamp"] = this->epochSeconds;
        serializeJson(jsonString, Serial); // this prints to the serial output remove later
        Serial.println();
        String jsonStringOutput;
        serializeJson(jsonString, jsonStringOutput);
        return jsonStringOutput;
    }
};
#endif
