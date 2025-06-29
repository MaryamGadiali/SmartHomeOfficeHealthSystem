#include "FileHandling.h"
#include <LittleFS.h>
#include <Arduino.h>
#include <esp_now.h>
#include "Global.h"
// Implementation file

#define FORMAT_LITTLEFS_IF_FAILED true // Creates a partition on esp32 dedicated to the filesystem

// Creates the device file if it does not exist
// Returns true if the file does not exist or
// if the file exists but there is no hub - this means the device has not been set up yet
// Returns false if the file exists and there is a hub
bool FileHandling::setUp()
{
  if (!LittleFS.begin(FORMAT_LITTLEFS_IF_FAILED))
  {
    Serial.println("LittleFS mount failed");
    return true; // Cannot proceed if LittleFS fails, there is no handling for this
  }
  Serial.println("LittleFS mounted successfully");

  if (!LittleFS.exists("/sensor"))
  {
    Serial.println("Sensor file does not exist");
    File sensorFile = LittleFS.open("/sensor", "w");
    if (sensorFile)
    {
      sensorFile.close();
      Serial.println("Sensor file created");
    }
    else
    {
      sensorFile.close();
      Serial.println("Error creating sensor file");
    }
    return true;
  }
  else if (LittleFS.exists("/sensor") && countNumOfLines() == 0)
  {
    return true;
  }
  return false;
}

// Writes the hub's MAC address to the file
// Takes in the address of the peerInfo object that contains the hub's MAC address
// Returns true if the hub's MAC address was successfully written to the file
// Returns false if there was an error writing to the file
bool FileHandling::writeNewHubToFile(uint8_t *peerInfoObjectAddress)
{
  clearFile(); // Removes any existing hub from the file

  Serial.println("Writing new hub to file");
  File sensorFile = LittleFS.open("/sensor", "a");
  if (sensorFile)
  {
    sensorFile.write(peerInfoObjectAddress, 6);
    sensorFile.write('\n');
    sensorFile.close();
    return true;
  }
  else
  {
    Serial.println("Error writing to file");
    return false;
  }
}

// Clears the contents of the file
void FileHandling::clearFile()
{
  Serial.println("Clearing the contents of the file");
  File sensorFile = LittleFS.open("/sensor", "w");
  if (sensorFile)
  {
    sensorFile.close();
    Serial.println("File cleared");
  }
  else
  {
    Serial.println("Error clearing file");
  }
}

// Deletes the file
void FileHandling::deleteFile()
{
  Serial.println("Deleting the file");
  if (LittleFS.remove("/sensor"))
  {
    Serial.println("File deleted");
  }
  else
  {
    Serial.println("Error deleting file");
  }
}

// Adds the existing hub to the ESP-NOW communication peer list
// Sets the hubPeerAddress global variable to the MAC address of the hub from the file
void FileHandling::addExistingHubToEspNowCommunication()
{
  Serial.println("Reached addExistingHubToEspNowCommunication");
  if(countNumOfLines()==0){
    Serial.println("Hub is not in file yet");
    return;
  }
  File sensorFile = LittleFS.open("/sensor", "r");
  if (sensorFile)
  {
    uint8_t macAddress[6];
    sensorFile.read(macAddress, 6);

    esp_now_peer_info_t peerInfo = {};
    memcpy(peerInfo.peer_addr, macAddress, 6);
    // memcpy(peerInfo.lmk,localKey,16);
    memcpy(hubPeerAddress, peerInfo.peer_addr, sizeof(peerInfo.peer_addr));
    isHubPeerAddressPopulated=true;
    // peerInfo.encrypt = true;
    esp_now_add_peer(&peerInfo);
    sensorFile.close();
  }
  else
  {
    Serial.println("Error reading file");
  }
}

// Counts the number of lines in the file
// Returns the number of lines in the file - should only be 1 as only 1 hub
int FileHandling::countNumOfLines()
{
  Serial.println("Counting number of lines in file");
  File sensorFile = LittleFS.open("/sensor", "r");
  int lines = 0;
  if (sensorFile)
  {
    while (sensorFile.available())
    {
      if (sensorFile.read() == '\n')
      {
        lines++;
      }
    }
    sensorFile.close();
  }
  else
  {
    Serial.println("Error reading file");
  }
  Serial.println("There are " + String(lines) + " lines in the file");
  return lines;
}
