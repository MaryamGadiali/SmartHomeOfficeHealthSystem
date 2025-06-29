#ifndef SetUpH
#define SetUpH
#include <HTTPClient.h>
#include <WiFi.h>
// Definition file

// Contains methods used to set up the devices on the network
class SetUp
{

public:
  static bool pairHub();                 // Pairs the hub and activates it on the application
  static bool pairSeatingSensor();       // Adds the seating sensor to the network and activates it on the application
  static bool receiveSeatingSensorMac(); // Retrieves the mac address of the seating sensor from the application for use in espnow communciations
  static bool addNewDeviceToNetwork();   // Adds a new sensor (and actuator) to the network and activates it on the application
};

#endif