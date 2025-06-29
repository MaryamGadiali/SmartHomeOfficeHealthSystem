#include "FileHandling.h"
#include <LittleFS.h>
#include "Message.h"
#include "Global.h"
// Implementation file

#define FORMAT_LITTLEFS_IF_FAILED true // Creates a partition on esp32 dedicated to the filesystem

// Creates the device file if it does not exist
// Returns true if the file is empty
// Returns false if the file exists and there is a hub
bool FileHandling::isFirstTimeSetUp()
{
  if (!LittleFS.begin(FORMAT_LITTLEFS_IF_FAILED))
  {
    Serial.println("LittleFS mount failed. Formatting...");
    return true; // Cannot proceed if LittleFS fails, there is no handling for this
  }
  Serial.println("LittleFS mounted successfully");

  if (!LittleFS.exists("/hub"))
  {
    Serial.println("Hub file does not exist");
    File hubFile = LittleFS.open("/hub", "w");
    if (hubFile)
    {
      hubFile.close();
      Serial.println("Hub file created");
    }
    else
    {
      hubFile.close();
      Serial.println("Error creating hub file");
    }
    return true;
  }
  else if (LittleFS.exists("/hub") && FileHandling::countNumOfLines() == 0)
  {
    return true;
  }
  return false;
}

// Checks if the sensor type already exists in the file
// Takes in the sensor type
// Returns true if the sensor type already exists
// Returns false if the sensor type does not exist
bool FileHandling::checkDuplicateRecords(String &sensorType)
{
  File hubFile = LittleFS.open("/hub", "r");
  bool isDuplicate = false;
  while (hubFile.available())
  {
    String line = hubFile.readStringUntil('\n');
    if (line.startsWith(sensorType))
    {
      isDuplicate = true;
      break;
    }
  }
  hubFile.close();
  return isDuplicate;
}

// Writes the sensor details in the file in the format "sensorType,MACAddress"
// Takes in the address of the peerInfo object that contains the sensor's MAC address, and the sensor type
// Returns true if the sensor's MAC address was successfully written to the file
// Returns false if there was an error writing to the file
bool FileHandling::writeNewSensorToFile(esp_now_peer_info_t &peerInfoObjectAddress, String &sensorType)
{
  bool isDuplicate = checkDuplicateRecords(sensorType);
  File hubFile = LittleFS.open("/hub", "a");
  if (hubFile && !isDuplicate)
  {
    hubFile.write((const uint8_t *)sensorType.c_str(), sensorType.length());
    hubFile.write((const uint8_t *)",", 1);
    hubFile.write(peerInfoObjectAddress.peer_addr, 6);
    hubFile.write('\n'); // To seperate records
    hubFile.close();
    return true;
  }
  else if (isDuplicate)
  {
    Serial.println("Duplicate record found");
    return false;
  }
  else
  {
    Serial.println("Error writing to file");
    return false;
  }
}

// Deletes the file
void FileHandling::deleteFile()
{
  Serial.println("Reached deleteFile");
  if (LittleFS.remove("/hub"))
  {
    Serial.println("File deleted");
  }
  else
  {
    Serial.println("Error deleting file");
  }
}

// Adds the existing sensors from the file to the ESP-NOW communication peer list and the global peerMap
// Returns the number of connections stored in the file
int FileHandling::addExistingPeersToEspNowCommunication()
{
  esp_now_deinit(); // Turns off esp now
  peerMap.clear();  // Clears the peer map

  int numOfConnections = 0;
  File hubFile = LittleFS.open("/hub", "r");

  // Sets up esp now
  esp_now_init();
  esp_now_register_recv_cb(OnDataRecv); // Registers the receive callback function
  // esp_err_t result = esp_now_set_pmk((uint8_t *)primaryKey);
  // Serial.println(esp_err_to_name(result));

  if (hubFile)
  {
    while (hubFile.available())
    {
      // Calculate how many bytes there are before the first comma as the sensor name will be variable size
      int commaPosition = 0;
      while (hubFile.available() && hubFile.peek() != ',')
      {
        hubFile.read();
        commaPosition++;
      }
      if (!hubFile.available()) // Reached end of file
      {
        break;
      }

      char sensorType[commaPosition]; // Allocates memory for the sensor type

      // Goes back to start of line and reads the sensor type into the sensorType array
      hubFile.seek(hubFile.position() - commaPosition);
      hubFile.readBytes(sensorType, commaPosition);

      hubFile.read(); // Skips over the comma

      // Reads the mac address by starting from the comma - always 6 bytes
      uint8_t deviceMAC[6];
      hubFile.read(deviceMAC, 6);

      // Converts the mac address to std::array so it can be stored in map
      std::array<uint8_t, 6> deviceMACArray;
      for (int i = 0; i < 6; i++)
      {
        deviceMACArray[i] = deviceMAC[i];
      }

      // Cleans the sensor type by removing any unexpected characters
      String cleanSensorType = "";
      for (int i = 0; i < commaPosition; i++)
      {
        if (isAlpha(sensorType[i]))
        {
          cleanSensorType += sensorType[i];
        }
      }
      // Adds to peer map
      peerMap[cleanSensorType] = deviceMACArray;
      numOfConnections++;

      // Add to esp now current session of peers - this is where you add the encrypt
      esp_now_peer_info_t peerInfo = {};
      // memcpy(peerInfo.lmk,localKey,16);
      memcpy(peerInfo.peer_addr, deviceMACArray.data(), 6);
      // peerInfo.encrypt = true;
      esp_now_add_peer(&peerInfo);

      // Skips over new line character
      hubFile.read();
    }
    hubFile.close();
  }
  else
  {
    Serial.println("Error reading file");
    return 0;
  }
  return numOfConnections;
}

// Counts the number of lines in the file
// Returns the number of lines in the file
int FileHandling::countNumOfLines()
{
  File hubFile = LittleFS.open("/hub", "r");
  int lines = 0;
  if (hubFile)
  {
    while (hubFile.available())
    {
      if (hubFile.read() == '\n')
      {
        lines++;
      }
    }
  }
  else
  {
    Serial.println("Error reading file");
  }
  return lines;
}

// Deletes a specific line from the file
// Takes in the string that the line starts with
void FileHandling::deleteSpecificLine(String startsWith)
{
  File hubFile = LittleFS.open("/hub", "r");
  String linesToKeep = "";
  while (hubFile.available())
  {
    String line = hubFile.readStringUntil('\n');
    if (!line.startsWith(startsWith))
    {
      linesToKeep += line + "\n"; // need to check this
    }
  }
  hubFile.close();
  hubFile = LittleFS.open("/hub", "w");
  hubFile.write((const uint8_t *)linesToKeep.c_str(), linesToKeep.length());
  hubFile.close();
}