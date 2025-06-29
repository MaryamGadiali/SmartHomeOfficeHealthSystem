#ifndef LEDCHANGERH
#define LEDCHANGERH
#include <Arduino.h>
// Definition file

// Class to change the colour of the RGB LED
class LEDChanger
{
public:
  static void changeColour(String colour); // Changes the colour of the RGB LED
};

#endif