#include "APICommunication.h"
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include "Global.h"
#include "JsonHandling.h"
#include <Arduino.h>
#include "LEDChanger.h"
#include <base64.h>
#include "WifiSetup.h"
// Implementation file

// Sends a GET request to the server and handles the json response
// Takes in the endpoint url and the timeout period
// Returns Success if the request was completed successfully
String APICommunication::GETRequest(String endpoint, int timeout)
{
    JsonHandling::handleJson(GETRequestDirect(endpoint, timeout));
    return "Success";
}

// Sends a GET request to the server and returns the direct text response - no json handling
// Take in the endpoint url and the timeout period
// Returns the direct text response from the server
// If the timeout is 0, the function will keep going until a successful response is received
String APICommunication::GETRequestDirect(String endpoint, int timeout)
{
    LEDChanger::changeColour("Green");

    if (timeout == 0)
    {
        while (true)
        {
            https.begin(endpoint.c_str());
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.GET();
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                https.end();
                LEDChanger::changeColour("Blue");
                return response;
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);
                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                        WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }  
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }
    else
    {
        unsigned long startTime = millis();
        while ((millis() - startTime) < timeout)
        {
            https.begin(endpoint.c_str());
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.GET();
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                https.end();
                LEDChanger::changeColour("Blue");
                return response;
            }
            else
            {
                Serial.println("Error code from get request: ");
                Serial.println(httpResponseCode);
                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                  
                    if (WiFi.status() != WL_CONNECTED)
                      {
                       //wifiManager.setConnectTimeout(7200);
                       WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }
    https.end();
    String response = "Timeout";
    LEDChanger::changeColour("Blue");
    return response;
}

// Sends a POST request to the server and handles the json response
// Takes in the endpoint url, the data to be sent and the timeout period
// Returns Success if the request was completed successfully
// If the timeout is 0, the function will keep going until a successful response is received
String APICommunication::POSTRequest(String endpoint, String data, int timeout)
{
    LEDChanger::changeColour("Green");
    if (timeout == 0)
    {
        while (true)
        {
            https.begin(client, endpoint.c_str());
            https.addHeader("Content-Type", "application/json");
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.POST(data);
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                https.end();
                JsonHandling::handleJson(response);
                response = "Success";
                LEDChanger::changeColour("Blue");
                return response;
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                         WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }
    else
    {
        unsigned long startTime = millis();
        while ((millis() - startTime) < timeout)
        {
            https.begin(client, endpoint.c_str());
            https.addHeader("Content-Type", "application/json");
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.POST(data);
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                https.end();
                JsonHandling::handleJson(response);
                response = "Success";
                LEDChanger::changeColour("Blue");
                return response;
            }
            else
            {
                Serial.println("Error code from post request: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                       // wifiManager.setConnectTimeout(7200);
                        WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }
    https.end();
    String response = "Timeout";
    LEDChanger::changeColour("Blue");
    return response;
}

// Keeps polling the get request until a non default response is received - no json handling
// Takes in the endpoint url, the default response, and the timeout period
// Returns the response from the server
// If the timeout is 0, the function will keep going until a successful response is received
String APICommunication::pollingGETRequest(String endpoint, String defaultResponse, int timeout)
{
    LEDChanger::changeColour("Green");
    if (timeout == 0)
    {
        while (true)
        {
            https.begin(endpoint.c_str());
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.GET();
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                if (response != defaultResponse)
                {
                    https.end();
                    LEDChanger::changeColour("Blue");
                    return response;
                }
                else
                {
                    https.end();
                }
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                         WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }
    else
    {
        unsigned long startTime = millis();
        while ((millis() - startTime) < timeout)
        {
            https.begin(endpoint.c_str());
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.GET();
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                if (response != defaultResponse)
                {
                    https.end();
                    LEDChanger::changeColour("Blue");
                    return response;
                }
                else
                {
                    https.end();
                }
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                         WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
        https.end();
        String response = "Timeout";
        LEDChanger::changeColour("Blue");
        return response;
    }
}

// Keeps polling the post request until a non default response is received - no json handling
// Takes in the endpoint url, the data to be sent, the default response, and the timeout period
// Returns the response from the server
// If the timeout is 0, the function will keep going until a successful response is received
String APICommunication::pollingPOSTRequest(String endpoint, String data, String defaultResponse, int timeout)
{
    LEDChanger::changeColour("Green");

    if (timeout == 0)
    {
        while (true)
        {
            https.begin(client, endpoint.c_str());
            https.addHeader("Content-Type", "application/json");
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.POST(data);
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                if (response != defaultResponse)
                {
                    https.end();
                    LEDChanger::changeColour("Blue");
                    return response;
                }
                else
                {
                    https.end();
                }
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                         WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
    }

    else
    {
        unsigned long startTime = millis();
        while ((millis() - startTime) < timeout)
        {
            https.begin(client, endpoint.c_str());
            https.addHeader("Content-Type", "application/json");
            https.addHeader("Authorization","Basic "+base64::encode(String(apiUsername)+":"+String(apiPassword)));
            int httpResponseCode = https.POST(data);
            if (httpResponseCode == 200)
            {
                String response = https.getString();
                Serial.println("Response from server: ");
                Serial.println(response);
                if (response != defaultResponse)
                {
                    https.end();
                    LEDChanger::changeColour("Blue");
                    return response;
                }
                else
                {
                    https.end();
                }
            }
            else
            {
                Serial.println("Error code from server: ");
                Serial.println(httpResponseCode);

                if (httpResponseCode == -1) // Can't connect to server
                {
                    LEDChanger::changeColour("Purple");
                    if (WiFi.status() != WL_CONNECTED)
                      {
                        // wifiManager.setConnectTimeout(7200);
                         WiFi.disconnect();
                        WiFi.reconnect();
                        while (WiFi.status() != WL_CONNECTED){
                          delay(5000); // 5 seconds
                          Serial.println("Connecting to home wifi...");
                        }
                      }
                }
                else
                {
                    Serial.println("Response from server: ");
                    Serial.println(https.getString());
                }
                https.end();
            }
            delay(3000);
        }
        https.end();
        String response = "Timeout";
        LEDChanger::changeColour("Blue");
        return response;
    }
}
