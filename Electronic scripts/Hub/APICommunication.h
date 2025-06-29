#ifndef APICommunicationH
#define APICommunicationH
#include <HTTPClient.h>
#include <WiFi.h>
// Definition file

// Contains methods used to communicate with the web api
class APICommunication
{
public:
  static String GETRequest(String endpoint, int timeout);                                              // Sends a GET request to the server and handles the json response
  static String GETRequestDirect(String endpoint, int timeout);                                        // Sends a GET request to the server and returns the direct text response
  static String pollingGETRequest(String endpoint, String defaultResponse, int timeout);               // Keep polling the get request until a non default response is received - no json handling
  static String POSTRequest(String endpoint, String data, int timeout);                                // Sends a POST request to the server and handles the json response
  static String pollingPOSTRequest(String endpoint, String data, String defaultResponse, int timeout); // Keep polling the post request until a non default response is received - no json handling
};

#endif