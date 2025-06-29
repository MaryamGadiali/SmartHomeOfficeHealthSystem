#include "SensorReading.h"
#include "Global.h"
#include <Arduino.h>
#include "LEDChanger.h"
#include "SensorData.h"
#include "HubCommunication.h"

//This records the ultrasonic reading, it measures the distance to the user
//Sometimes it can give erroneous large values (considered over 60), if this happens for more than 3 times
//Then the first distance is taken and sent
//Command 8 is sent to the API, command 13 is sent to the hub to manage the threshold action
bool SensorReading::takeDistanceReading() {
  if (isHubPeerAddressPopulated) {
    LEDChanger::changeColour("Green");
    long duration = 0;
    long distance = 0;

    while (duration == 0) {
      Serial.println("Sending pulse");
      digitalWrite(TRIGPIN, LOW);
      delay(1000);
      digitalWrite(TRIGPIN, HIGH);
      delayMicroseconds(10);  //Short pulse
      digitalWrite(TRIGPIN, LOW);
      duration = pulseIn(ECHOPIN, HIGH, 30000);
      Serial.println("Duration: ");
      Serial.println(duration);
      distance = (duration * 0.034) / 2;  //Distance in cm, 0.034 is speed of sound in cm per microsecond
      Serial.println("Distance: ");
      Serial.println(distance);
      delay(2000);

      if (distance > 60) {  //Handling possible error values, by checking at most 5 more times
        for (int i = 0; i < 3; i++) {
          Serial.println("Sending pulse");
          digitalWrite(TRIGPIN, LOW);
          delay(1000);
          digitalWrite(TRIGPIN, HIGH);
          delayMicroseconds(10); 
          digitalWrite(TRIGPIN, LOW);
          long newDuration = pulseIn(ECHOPIN, HIGH, 30000);
          Serial.println("Duration: ");
          Serial.println(newDuration);
          long newDistance = (newDuration * 0.034) / 2;
          Serial.println("Distance: ");
          Serial.println(newDistance);

          if (newDistance < 60 && newDistance > 0) {
            distance = newDistance;
            break;
          }
          delay(2000);
        }
      }
    }

    LEDChanger::changeColour("Blue");

    String jsonMessage = SensorData(distance, rtc.getLocalEpoch()).toJsonObject();
    HubCommunication::sendESPNowMessage(8, jsonMessage);
    delay(1000);
    HubCommunication::sendESPNowMessage(13, String(std::to_string(distance).c_str()));
    return true;
  } else {
    return false;
  }
}
