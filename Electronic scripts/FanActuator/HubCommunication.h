#ifndef HubCommunicationH
#define HubCommunicationH
#include <Arduino.h>
// Definition file

// Class to handle communication with the hub
class HubCommunication
{
public:
  static void configureChannel();                             // Sets the sensor to the correct channel for esp now
  static bool sendESPNowMessage(int command, String message); // Sends a message to the hub
};

#endif