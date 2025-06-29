#ifndef MESSAGEH
#define MESSAGEH
#include <esp_now.h>
#include <string.h>

//Class to define the structure of the message that is sent with ESPNOW
class Message
{
public:
    int command;        // 4 bytes
    char data[100];     // 100 bytes
    uint8_t srcAddr[6]; // 6 bytes

    // Default constructor
    Message() : command(0), data(""), srcAddr({0}) {};
};
#endif