#ifndef FILEHANDLINGH
#define FILEHANDLINGH
#include <Arduino.h>
#include <LittleFS.h>
#include <esp_now.h>
#include <WiFi.h>
// Header file

// Class that handles file operations
class FileHandling
{
public:
  static bool isFirstTimeSetUp();                                                                   // Checks if the network has been set up before
  static bool writeNewSensorToFile(esp_now_peer_info_t &peerInfoObjectAddress, String &sensorType); // Writes the sensor's MAC address to the file
  static void deleteFile();                                                                         // Deletes the file
  static int addExistingPeersToEspNowCommunication();                                               // Adds the existing sensors from the file to the ESP-NOW communication peer list and the global peerMap
  static int countNumOfLines();                                                                     // Counts the number of lines in the file
  static void deleteSpecificLine(String startsWith);                                                // Deletes a specific line from the file
  static bool checkDuplicateRecords(String &sensorType);                                            // Checks if a sensor type already exists in the file
};

#endif