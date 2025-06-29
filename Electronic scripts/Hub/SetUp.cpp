#include "SetUp.h"
#include "APICommunication.h"
#include <WiFiClientSecure.h>
#include "Global.h"
#include "DeviceCommunication.h"
#include "FileHandling.h"
#include "LEDChanger.h"
// Implementation file

// Pairs the hub and activates it on the application
bool SetUp::pairHub()
{
  String response = APICommunication::pollingPOSTRequest((serverName + "/pairHub?hubMacAddress=" + WiFi.macAddress()), "", "Hub code not used", 0);
  return true;
}

// Adds the seating sensor to the network and activates it on the application
bool SetUp::pairSeatingSensor()
{
  if (receiveSeatingSensorMac())
  {
    Serial.println("Successfully retrieved seating sensor mac");
  }
  else
  {
    Serial.println("Failed");
  }
  return true;
}

// Retrieves the mac address of the seating sensor from the application for use in espnow communciations
bool SetUp::receiveSeatingSensorMac()
{
  String response = APICommunication::pollingGETRequest(serverName + "/getSeatingSensorMacAddress?hubMacAddress=" + WiFi.macAddress(), "Not valid", 0);
  if (response == "Not valid" || response == "Timeout")
  {
    return false;
  }
  else
  {
    DeviceCommunication::configureWifiChannel(1, false); // Sets the sensor and hub on same channel
    DeviceCommunication::addDeviceToPeerList(response, "Occupancy");
    return true;
  }
}

// Adds a new sensor (and actuator) to the network and activates it on the application
bool SetUp::addNewDeviceToNetwork()
{
  // Polls for 30 seconds to see if there are any new sensors to add - button may have been pressed by accident
  String response = APICommunication::pollingGETRequest(serverName + "/getSensorMacAddress?hubMacAddress=" + WiFi.macAddress(), "0,No new sensors found", 0);
  if (response == "Timeout" || response == "0,No new sensors found")
  {
    return false;
  }
  else
  {
    // Substrings the result, first index is the number of new devices, second is the comma,then the mac address, then the comma, then the sensor type name
    int amountOfNewDevices = response.substring(0, 1).toInt();
    String sensorMacAddress = response.substring(2, 19); // Mac address takes up 17 characters
    String sensorType = response.substring(20);
    DeviceCommunication::configureWifiChannel(1, false); // Sets the device and hub on same channel
    DeviceCommunication::addDeviceToPeerList(sensorMacAddress, sensorType);
    if (amountOfNewDevices == 2)
    {
      LEDChanger::changeColour("Pink");
      delay(5000);
      // Can't proceed until the actuator is added
      String response = APICommunication::pollingGETRequest(serverName + "/getActuatorMacAddress?hubMacAddress=" + WiFi.macAddress(), "No new actuators found", 0);

      // First 17 letters will be the mac address, then the comma, then rest is the actuator's name
      String actuatorMacAddress = response.substring(0, 17);
      String actuatorType = response.substring(18);       
      DeviceCommunication::configureWifiChannel(1, false); // Sets the actuator and hub on same channel
      DeviceCommunication::addDeviceToPeerList(actuatorMacAddress, actuatorType);
    }
    FileHandling::addExistingPeersToEspNowCommunication();
    return true;
  }
}