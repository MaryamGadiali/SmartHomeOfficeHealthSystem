#ifndef FILEHANDLINGH
#define FILEHANDLINGH
#include <Arduino.h>
#include <esp_now.h>
// Header file

// Class that handles file operations
class FileHandling
{
public:
  static bool setUp();                                           // Creates the device file if it does not exist
  static bool writeNewHubToFile(uint8_t *peerInfoObjectAddress); // Writes the hub's MAC address to the file
  static void clearFile();                                       // Clears the contents of the file
  static void deleteFile();                                      // Deletes the file
  static void addExistingHubToEspNowCommunication();             // Adds the existing hub to the ESP-NOW communication peer list
  static int countNumOfLines();                                  // Counts the number of lines in the file
};

#endif