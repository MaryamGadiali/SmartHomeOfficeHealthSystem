#include "Global.h"
#include "LEDChanger.h"
// Implementation file

// Changes the colour of the RGB LED
// Takes in the colour to change to
void LEDChanger::changeColour(String colour)
{
  delay(10);
  if (colour == "Red")
  {
    analogWrite(redPin, 0);
    analogWrite(greenPin, 255);
    analogWrite(bluePin, 255);
  }
  else if (colour == "Green")
  {
    analogWrite(redPin, 255);
    analogWrite(greenPin, 0);
    analogWrite(bluePin, 255);
  }
  else if (colour == "Blue")
  {
    analogWrite(redPin, 255);
    analogWrite(greenPin, 255);
    analogWrite(bluePin, 0);
  }
  else if (colour == "Purple")
  {
    analogWrite(redPin, 95);
    analogWrite(greenPin, 230);
    analogWrite(bluePin, 15);
  }
  else if (colour == "Pink")
  {
    analogWrite(redPin, 0);
    analogWrite(greenPin, 235);
    analogWrite(bluePin, 108);
  }
  else if (colour == "Orange")
  {
    analogWrite(redPin, 0);
    analogWrite(greenPin, 90);
    analogWrite(bluePin, 255);
  }
  else
  {
    Serial.println("Invalid colour");
  }
  delay(10);
}