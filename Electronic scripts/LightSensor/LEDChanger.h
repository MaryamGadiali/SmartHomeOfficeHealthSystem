#ifndef LEDCHANGERH
#define LEDCHANGERH
#include <Arduino.h>


class LEDChanger{
  public:
    static void changeColour(String colour);
};

#endif