#ifndef JSONHANDLINGH
#define JSONHANDLINGH

#include <ArduinoJson.h>
#include "DeviceCommunication.h"
#include "Global.h"
#include <string>
#include "FileHandling.h"
// Definition file

// Class that handles json responses
class JsonHandling{
    public:
    static void handleJson(String jsonResponse); //Parses the json response and performs the commands sent from the application
};

#endif