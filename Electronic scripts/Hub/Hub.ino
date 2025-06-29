#include "SetUp.h"
#include <WiFiClientSecure.h>
#include <WiFiManager.h>
#include "DeviceCommunication.h"
#include "Global.h"
#include "APICommunication.h"
#include "Message.h"
#include "WifiSetup.h"
#include "FileHandling.h"
#include <esp_now.h>
#include "InternalClock.h"
#include <string>
#include <ArduinoJson.h>
#include "LEDChanger.h"

// Used for retrieving pending commands from the application every 15 seconds
unsigned long lastSendTime;
unsigned long sendInterval = 15000; // 15 seconds

// Used for the heartbeat protocol
// unsigned long heartbeatTime;
unsigned long heartbeatInterval = 180000; // Sends the heartbeat every 3 minutes if not broadcasted
unsigned long broadcastInterval = 120000; // Broadcasts the AP every 2 mins if not all devices are connected

void setup()
{
  Serial.begin(115200);
  delay(1000); // This is to give the serial monitor time to initialise

  // Setting the pins of the components
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  LEDChanger::changeColour("Blue");

  Serial.println("Enter command"); // This is an option for the marker to point the hub to their private ip address
  delay(7000);

  //Debug commands from start up (through serial terminal)
  if (Serial.available() > 0)
  { // Checks if any command is received
    String command = Serial.readStringUntil('\n');
    command.trim();
    Serial.println("Command is: " + command);
    if (command == "0")
    {
      Serial.println("Enter the ip address to point to");
      delay(15000); // 15 seconds
      if (Serial.available() > 0)
      {
        String ipaddressMessage = Serial.readStringUntil('\n');
        serverName = "https://" + ipaddressMessage + ":8443"; // Sets the global variable to the ip address
      }
    }
    else if (command == "2")
    {
      FileHandling::isFirstTimeSetUp();
      FileHandling::deleteFile();
    }
    else if (command == "11")
    {
      wifiManager.resetSettings();
    }
    else
    {
      Serial.println("Invalid command");
    }
  }

  Serial.println("Started up");

  // Connecting to home wifi
  LEDChanger::changeColour("Red");
  WifiSetup::setUpWifiManager();
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(5000); // 5 seconds
    Serial.println("Connecting to home wifi...");
  }
  LEDChanger::changeColour("Blue");

  client.setInsecure(); // Skips certificate validation for my self signed cert

  // Sets up the internal RTC to match real time
  InternalClock::configureInternalClock();

  // If no connected devices are recorded, then it is the first time set up
  if (FileHandling::isFirstTimeSetUp())
  {
    if (WiFi.status() == WL_CONNECTED)
    {
      bool hubPairSuccessful = SetUp::pairHub(); // Pairs the hub to the user on the application
      if (hubPairSuccessful)
      {
        bool sensorPairSuccessful = SetUp::pairSeatingSensor(); // Pairs the seating sensor to the hub
        if (sensorPairSuccessful)
        {
          Serial.println("Hub and occupancy pairing : Successful ");
        }
        else
        {
          Serial.println("Occupancy sensor pairing unsucessful");
        }
      }
      else
      {
        Serial.println("Hub pairing unsucessful");
      }
    }
    Serial.println("Reached the end of first time set up");

    // Gets the threshold values from the application and adds the seating sensor to the peer list and ESP-NOW communication
    APICommunication::GETRequest(serverName + "/getThresholds?hubMacAddress=" + WiFi.macAddress() + "&isStartUp=False", 0);
    FileHandling::addExistingPeersToEspNowCommunication();
  }
  else // This is for when at least the hub and occupancy sensor has been set up
  {
    Serial.println("Not first time set up");
    APICommunication::GETRequest(serverName + "/getThresholds?hubMacAddress=" + WiFi.macAddress(), 0);
    int numOfConnections =FileHandling::countNumOfLines();
    DeviceCommunication::configureWifiChannel(numOfConnections);
    FileHandling::addExistingPeersToEspNowCommunication();
  }
  DeviceCommunication::sendESPNowBroadcastMessage(7, (static_cast<String>(rtc.getLocalEpoch())));
  DeviceCommunication::sendESPNowBroadcastMessage(23, "Are you there");
  heartbeatTime = millis();
  Serial.println("Starting loop");
}

void loop()
{
  LEDChanger::changeColour("Blue");
  // Serial.println("Queue size: ");
  // Serial.println(uxQueueMessagesWaiting(messageQueue));

  // Check java pending commands every 3 minutes
  if (millis() - lastSendTime > sendInterval)
  {
    Serial.println("Checking for pending commands");
    String pendingCommands = APICommunication::GETRequest(serverName + "/getPendingCommands?hubMacAddress=" + WiFi.macAddress(), 15000); // 15 seconds
    lastSendTime = millis();
  }

  // Heartbeat protocol check
  // Broadcasts the AP every 3 minutes and then sends the hearbeat if not all devices are connected
  // Sends the heartbeat every 5 minutes if not broadcasted within that time frame
  // Also sends the rtc time to all devices to prevent time drift
  if ((millis() - heartbeatTime > broadcastInterval && numOfActiveConnections < peerMap.size()) || (millis() - heartbeatTime > heartbeatInterval))
  {
    Serial.println("Peer map size: ");
    Serial.println(peerMap.size());
    Serial.println("Number of active connections: ");
    Serial.println(numOfActiveConnections);
    if (numOfActiveConnections < peerMap.size()){
      DeviceCommunication::configureWifiChannel(peerMap.size(), true, 15000); // 15 seconds 
    }
    InternalClock::configureInternalClock();
    DeviceCommunication::sendESPNowBroadcastMessage(7, (static_cast<String>(rtc.getLocalEpoch())));
    if (!isSensorPause) // To avoid waking up the sensors if they are paused
    {
      delay(1000);
      numOfActiveConnections = 0;
      DeviceCommunication::sendESPNowBroadcastMessage(23, "Are you there");
    }
    heartbeatTime = millis();
  }

  //Debug commands from serial terminal
  if (Serial.available() > 0)
  {                                                // Check if data is available
    String command = Serial.readStringUntil('\n'); // Read the message
    command.trim();                                // Remove any trailing spaces or newline characters
    Serial.println("Command is: " + command);
    if (command == "1")
    {
      wifiManager.resetSettings();
    }
    else if (command == "2")
    {
      FileHandling::deleteFile();
    }
    else if (command == "11")
    {
      wifiManager.resetSettings();
    }
    else if (command == "broadcast")
    {
      heartbeatTime = heartbeatTime-180000;
    }
    else if (command == "light")
    {
      FileHandling::deleteSpecificLine("Light");
    }
    else if (command == "lamp")
    {
      FileHandling::deleteSpecificLine("Lamp");
    }
    else if (command == "send command 1 to lamp")
    {
      DeviceCommunication::sendESPNowMessage(peerMap["Lamp"].data(), 1, WiFi.macAddress().c_str());
    }
    else if (command == "send command 50 to seating")
    {

      DeviceCommunication::sendESPNowMessage(peerMap["Occupancy"].data(), 50, "Manual send 50");
    }
    else if (command == "send command 50 to lamp")
    {
      Message message;
      message.command = 50;
      strncpy(message.data, "50", sizeof(message.data));
      DeviceCommunication::sendESPNowMessage(peerMap["Lamp"].data(), 50, "Manual send 50");
    }
    else if (command == "send command 50 to light")
    {

      DeviceCommunication::sendESPNowMessage(peerMap["Light"].data(), 50, "Manual send 50");
    }
    else
    {
      Serial.println("Invalid command");
    }
  }

  // Process messages
  Message message;
  if (xQueueReceive(messageQueue, &message, 0))
  {
    int command = message.command;

    switch (command)
    {
    case 2:
    {
      Serial.println("Received Command 2");
      String endpoint = serverName + "/updateSeatingSensor?s=" + message.data;
      String response = APICommunication::POSTRequest(endpoint, "", 0);
      FileHandling::addExistingPeersToEspNowCommunication();
      break;
    }
    case 3:
    {
      Serial.println("Received Command 3");
      String endpoint = serverName + "/updateDevice?type=sensor&d=" + message.data;
      String response = APICommunication::POSTRequest(endpoint, "", 0);
      break;
    }
    case 4:
    {
      Serial.println("Received Command 4");
      String endpoint = serverName + "/updateDevice?type=actuator&d=" + message.data;
      String response = APICommunication::POSTRequest(endpoint, "", 0);
      break;
    }
    case 5: // Collecting sensor readings from light sensor
    {
      Serial.println("Received command 5");
      String endpoint = serverName + "/uploadSensorReading?type=light&h=" + WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, message.data, 0);
      lastSendTime = millis();
      break;
    }
    case 8: // Collecting sensor readings from seating sensor
    {
      Serial.println("Received command 8");
      String endpoint = serverName + "/uploadSensorReading?type=occupancy&h=" + WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, message.data, 0);
      lastSendTime = millis();
      break;
    }
    case 11: // Checking light thresholds
    {
      Serial.println("Received command 11");
      if (sensorThresholds.find("Light") != sensorThresholds.end())
      {
        float thresholdVal = sensorThresholds["Light"];
        float sensorReading = std::stof(message.data);
        if (sensorReading < thresholdVal)
        {
          DeviceCommunication::sendESPNowMessage(peerMap["Lamp"].data(), 12, "Switch on");
          String endpoint = serverName + "/switchActuatorState?ActuatorType=Lamp&state=On&h="+ WiFi.macAddress();
          APICommunication::POSTRequest(endpoint, "On command sent", 0);
          lastSendTime = millis();
        }
      }
      break;
    }
    case 13: // For occupancy threshold checking
    {
      Serial.println("Received command 13");
      if (sensorThresholds.find("Occupancy") != sensorThresholds.end())
      {
        float thresholdVal = sensorThresholds["Occupancy"];
        float sensorReading = std::stof(message.data);
        if (sensorReading > thresholdVal)
        {
          if (isUserPresent)
          {
            Serial.println("User not detected anymore");
            isUserPresent = false;
            DeviceCommunication::sendESPNowBroadcastMessage(20, "Pause");
            isSensorPause = true;
          }
        }
        else if (sensorReading < thresholdVal)
        {
          // if (!isUserPresent) //Commented this out in the cases where the hub resets whilst the sensors are paused
          // {
            Serial.println("User has been detected");
            isUserPresent = true;
            DeviceCommunication::sendESPNowBroadcastMessage(22, "Wake up");
            isSensorPause = false;
          // }
        }
      }
      break;
    }
    case 17: // Receiving and sending temperature readings
    {
      Serial.println("Received command 17");
      String endpoint = serverName + "/uploadSensorReading?type=temperature&h=" + WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, message.data, 0);
      lastSendTime = millis();
      break;
    }
    case 18: // Checking temperature thresholds
    {
      Serial.println("Received command 18");
      if (sensorThresholds.find("Temperature") != sensorThresholds.end())
      {
        float thresholdVal = sensorThresholds["Temperature"];
        float sensorReading = std::stof(message.data);
        if (sensorReading > thresholdVal)
        {
          DeviceCommunication::sendESPNowMessage(peerMap["Fan"].data(), 12, "Switch on");
          String endpoint = serverName + "/switchActuatorState?ActuatorType=Fan&state=On&h="+ WiFi.macAddress();
          APICommunication::POSTRequest(endpoint, "On command sent", 0);
          lastSendTime = millis();
        }
      }
      break;
    }
    case 24: // For the heartbeat protocol
    {
      Serial.println("Received command 24");
      numOfActiveConnections++;
      break;
    }
    case 25: // Receiving and sending heart rate readings
    {
      Serial.println("Received command 25");
      String endpoint = serverName + "/uploadSensorReading?type=heart&h=" + WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, message.data, 0);
      lastSendTime = millis();
      break;
    }
    case 26: //Updating Lamp state
    {
      Serial.println("Received command 26");
      String endpoint = serverName + "/switchActuatorState?ActuatorType=Lamp&state="+message.data+"&h="+ WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, "On command sent", 0);
      lastSendTime = millis();
      break;
    }
    case 27: //Updating Fan state
    {
      Serial.println("Received command 27");
      String endpoint = serverName + "/switchActuatorState?ActuatorType=Fan&state="+message.data+"&h="+ WiFi.macAddress();
      APICommunication::POSTRequest(endpoint, "On command sent", 0);
      lastSendTime = millis();
      break;
    }
    default:
      Serial.println("Invalid Command:");
      Serial.println(message.command);
      break;
    }
  }
  else
  {
    // Serial.println("No messages");
  }
  // delay(1000);
}
