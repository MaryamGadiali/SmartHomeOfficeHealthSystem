package com.example.officeFlow.controllers;

import com.example.officeFlow.model.*;
import com.example.officeFlow.services.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;

/**
 * Endpoints that only the hub can use
 */
@Controller
public class HubController {

    @Autowired
    private HubService hubService;

    @Autowired
    private UserService userService;

    @Autowired
    private ActuatorService actuatorService;

    @Autowired
    private SensorService sensorService;

    @Autowired
    private SensorReadingService sensorReadingService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private NotificationTypeService notificationTypeService;

    @Autowired
    private SensorTypeService sensorTypeService;

    @GetMapping("/getPendingCommands")
    @ResponseBody
    public String checkPendingCommands(@RequestParam("hubMacAddress") String hubMacAddress){
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        if (hub == null) {
            return "Hub not found";
        }
        return hubService.retrievePendingCommands(hub);
    }

    @PostMapping("/pairHub")
    @ResponseBody
    public String pairHub(@RequestParam("hubMacAddress") String hubMacAddress) {
        Map<String, String> response = new HashMap<>();
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        if (hub == null) {
            response.put("Status", "Error");
            response.put("Message", "Invalid Device");
        } else if (hub.isActive()) {
            response.put("Status", "Error");
            response.put("Message", "Hub is already paired");
        }
        else if(!hub.isPairCodeUsed()) { //This is to prevent a switched on hub from activating itself without user input
            response.put("Status", "Error");
            response.put("Message", "Hub code not used");
        }
        else {
            hub.setActive(true);
            hubService.save(hub);
            System.out.println("Hub activated");
            response.put("Status", "Success");
            response.put("Message", "Hub successfully replied");
        }
        return response.get("Message");
    }

    @GetMapping("/syncTime")
    @ResponseBody
    public Long syncTime() {
        return System.currentTimeMillis();
    }

    //Update the sensor object to have the parent hub link
    @PostMapping("/updateSeatingSensor")
    @ResponseBody
    public String updateSeatingSensor(@RequestParam("s") String seatingSensorMacAddress){
        System.out.println("Reached updateSeatingSensor");
        System.out.println("Seating Sensor Mac Address:" + seatingSensorMacAddress);
        Sensor sensor = sensorService.findByMacAddress(seatingSensorMacAddress);
        sensor.setActive(true);
        sensor.setImplementationTimestamp(java.time.LocalDateTime.now());
        sensor.setRemovalTimestamp(null);
        sensorService.save(sensor);
        return hubService.retrievePendingCommands(sensor.getSensorOwner().getHub());
    }

    //This is for the hub to update the sensor/actuator object to have the parent hub link
    @PostMapping("/updateDevice")
    @ResponseBody
    public String updateDevice(@RequestParam("type") String deviceType, @RequestParam("d") String deviceMacAddress){
        System.out.println("Reached updateDevice");
        System.out.println("Device Mac Address:" + deviceMacAddress);
        if (deviceType.equals("sensor")){
            Sensor sensor = sensorService.findByMacAddress(deviceMacAddress);
            sensor.setActive(true);
            sensor.setImplementationTimestamp(java.time.LocalDateTime.now());
            sensor.setRemovalTimestamp(null);
            sensorService.save(sensor);
            return hubService.retrievePendingCommands(sensor.getSensorOwner().getHub());
        }
        else if (deviceType.equals("actuator")){
            Actuator actuator = actuatorService.findByMacAddress(deviceMacAddress);
            actuator.setActive(true);
            actuator.setImplementationTimestamp(java.time.LocalDateTime.now());
            actuator.setRemovalTimestamp(null);
            actuatorService.save(actuator);
            return hubService.retrievePendingCommands(actuator.getActuatorOwner().getHub());
        }
        else{
            return "Error";
        }
    }

    @PostMapping("/uploadSensorReading")
    @ResponseBody
    public String uploadSensorReading(@RequestParam("type") String type, @RequestParam("h") String hubMacAddress, @RequestBody String sensorReading) {
        System.out.println("Received sensor reading");
        System.out.println("Hub Mac Address: " + hubMacAddress);
        System.out.println("Sensor type: " + type);
        System.out.println("Sensor reading" +sensorReading);

        Hub hub = hubService.findHubByMacAddress(hubMacAddress);

        if (hub==null){
            return "Hub not found";
        }
        if (hub.getHubOwner()==null){
            return "Hub owner not found";
        }
        System.out.println(hub.getHubOwner().getOwnedSensors().size());
        System.out.println(hub.getHubOwner().getOwnedActuators().size());

        //parse
        JSONObject jsonObject = new JSONObject(sensorReading);
        float reading = jsonObject.getFloat("reading");
        long timestamp = jsonObject.getLong("timestamp");

        System.out.println("Reading: " + reading);
        if (reading<1.1){
            reading=1.1f;
        }
        System.out.println("Timestamp in epoch second format: " + timestamp);

        LocalDateTime dateTime = LocalDateTime.ofEpochSecond(timestamp, 0, ZoneOffset.ofHours(1));
        System.out.println("LocalDateTime whihc should be in human readable format: " + dateTime);

        SensorType sensorType = sensorTypeService.findSensorTypeByName(type);
        Sensor sensor = sensorService.findSpecificSensor(hub, type);

        if (sensor == null){
            System.out.println("Sensor not found");
            return hubService.retrievePendingCommands(hub);
        }

        if (type.equals("occupancy")){
            float thresholdValue = (sensorService.findSpecificSensor(hub,"Occupancy")).getThreshold();
            hubService.updateLastTimeRecordedOfUser(hub, dateTime);
            if (reading<=thresholdValue){ //If is present
                if (hub.getSeatingStartTime()==0){ //If they have not been recorded as present yet, then do so
                    hub.setSeatingStartTime(dateTime.toEpochSecond(ZoneOffset.ofHours(1)));
                    hubService.save(hub);
                    return hubService.retrievePendingCommands(hub);
                }
                else{ //If is present, then check if the user has been sitting for over 30 minutes
                    System.out.println("User remained present");

                    //if user has been sitting for more than 30 minutes, send a notification of not sent in the last 10 minutes
                    if ((LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - hub.getSeatingStartTime()) > 1800) {
                        System.out.println("User has been sitting for over 30 minutes");
                        Optional<NotificationType> notificationType = notificationTypeService.findNotificationTypeById(3);
                        if (notificationType.isPresent()) {
                            if ((LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - notificationService.findTimeOfLatestNotificationSentOfType(hub.getHubOwner(),notificationType.get()) > 600 )) { //10 mins
                                Notification notification = new Notification();
                                notification.setNotificationType(notificationType.get());
                                notification.setTimestamp(LocalDateTime.now());
                                notification.setUserRecipient(hub.getHubOwner());
                                if (sensor.isShowNotifications() == false) { //If user has disabled notifications
                                    notification.setHasBeenDisplayed(true);
                                }
                                notificationService.save(notification);
                            }
                        }
                    }
                    return hubService.retrievePendingCommands(hub);
                }
            }
            else{
                System.out.println("User is not present");
                if (hub.getSeatingStartTime()==0){
                    System.out.println("No seating update");
                    return hubService.retrievePendingCommands(hub);
                }
                else{
                    //Insert a new record where the value is the time difference of the start time and last recorded time
                    reading = Float.parseFloat(String.format("%.2f",(dateTime.toEpochSecond(ZoneOffset.ofHours(1)) - hub.getSeatingStartTime())/60.0));
                    if (reading==1 || reading==1f){ //Found float bug where if value is exactly 1, it acts unexpectedly and shows big values
                        reading=1.1f;
                    }
                    //Occupancy records timestamp should just be todays date with 00:00
                    dateTime = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
                    hub.setSeatingStartTime(0);
                    hubService.save(hub);

                    //Saves to database
                    SensorReading sensorReadingObject = new SensorReading();
                    sensorReadingObject.setValue(reading);
                    sensorReadingObject.setTimestamp(dateTime);
                    sensorReadingObject.setType(sensorType);
                    sensorReadingObject.setUser(hubService.findHubByMacAddress(hubMacAddress).getHubOwner());
                    sensorReadingService.saveSensorReading(sensorReadingObject);

                    System.out.println("Created new occupancy record");
                    return hubService.retrievePendingCommands(hub);
                }
            }
        }

        //Saves to database
        SensorReading sensorReadingObject = new SensorReading();
        sensorReadingObject.setValue(reading);
        sensorReadingObject.setTimestamp(dateTime);
        sensorReadingObject.setType(sensorType);
        sensorReadingObject.setUser(hubService.findHubByMacAddress(hubMacAddress).getHubOwner());
        sensorReadingService.saveSensorReading(sensorReadingObject);

        //Capitalises the first letter of the sensor type
        String sensorTypeName = type.substring(0,1).toUpperCase() + type.substring(1);
            float thresholdValue;
                if (sensor!=null){
                    thresholdValue = sensor.getThreshold();
                    if (sensorTypeName.equals("Light")) {
                        if (reading < thresholdValue) { //Creates relevant notification
                            System.out.println("Sensor reading is below threshold");
                            Notification notification = new Notification();
                            Optional<NotificationType> notificationType;
                            notificationType = notificationTypeService.findNotificationTypeForSensorType(sensorTypeName, sensor.isAutomatePartnerActuatorBasedOnThresholds());
                            if (notificationType.isPresent()) {
                                notification.setNotificationType(notificationType.get());
                                notification.setTimestamp(LocalDateTime.now());
                                notification.setUserRecipient(hub.getHubOwner());
                                if(sensor.isShowNotifications()==false){
                                    notification.setHasBeenDisplayed(true);
                                }
                                notificationService.save(notification);
                            }
                        }
                    }
                    else if(sensorTypeName.equals("Temperature") || sensorTypeName.equals("Heart")){
                        if (reading > thresholdValue) { //Creates relevant notification
                            System.out.println("Sensor reading is above threshold");
                            Notification notification = new Notification();
                            Optional<NotificationType> notificationType;
                            notificationType = notificationTypeService.findNotificationTypeForSensorType(sensorTypeName, sensor.isAutomatePartnerActuatorBasedOnThresholds());
                            if (notificationType.isPresent()) {
                                notification.setNotificationType(notificationType.get());
                                notification.setTimestamp(LocalDateTime.now());
                                notification.setUserRecipient(hub.getHubOwner());
                                if(sensor.isShowNotifications()==false){
                                    notification.setHasBeenDisplayed(true);
                                }
                                notificationService.save(notification);
                            }
                        }
                    }
                }
                else{
                    System.out.println("Error: Sensor not found");
                }
        return hubService.retrievePendingCommands(hub);
    }


    //Hub retrieves the seating sensor's mac address
    @GetMapping("/getSeatingSensorMacAddress")
    @ResponseBody
    public String retrieveSeatingSensorMacAddress(@RequestParam("hubMacAddress") String hubMacAddress){
        System.out.println("Reached retrieveSeatingSensorMacAddress");
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        User user = hub.getHubOwner();
        if (user==null){
            return "Not valid"; //Means no hub owner found yet
        }
        Map<String, Sensor> sensors = user.getOwnedSensors();
        if (sensors.isEmpty()){
            return "Not valid"; //Means no sensor linked yet
        }
        else {
            //At this point, seating sensor should be the only sensor linked to the hub
            String key = sensors.keySet().iterator().next(); //Gets the first and only key
            String seatingSensorMacAddress = sensors.get(key).getMacAddress();
            System.out.println("Occupancy Mac Address: " + seatingSensorMacAddress);
            return seatingSensorMacAddress;
        }

    }

    //This is the get method for the hub to retrieve the new sensor's mac address
    @GetMapping("/getSensorMacAddress")
    @ResponseBody
    public String retrieveSensorMacAddress(@RequestParam("hubMacAddress") String hubMacAddress){
        System.out.println("Reached retrieveSensorMacAddress");
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        Map<String, Sensor> sensors = hub.getHubOwner().getOwnedSensors();
        if (sensors.isEmpty()){
            return "0,No new sensors found";
        }
        else {
            for (String key : sensors.keySet()) {
                if (!(sensors.get(key).isActive())){
                    String sensorMacAddress = sensors.get(key).getMacAddress();
                    System.out.println("New sensor Mac Address: " + sensorMacAddress);
                    String sensorType = sensors.get(key).getSensorType().getName();
                    System.out.println("Sensor Type: " + sensorType);

                    //If the sensor type has a paired actuator, return 2, else return 1
                    if (sensors.get(key).getSensorType().getPartnerActuatorType() != null){
                        return "2,"+sensorMacAddress+","+sensorType; //So it knows 2 new devices incoming
                    }
                    else{
                        return "1,"+sensorMacAddress+","+sensorType; //So it knows 1 new device incoming
                    }
                }
            }
            return "0,No new sensors found";
        }
    }

    //This is the get method for the hub to retrieve the actuator's mac address
    @GetMapping("/getActuatorMacAddress")
    @ResponseBody
    public String retrieveActuatorMacAddress(@RequestParam("hubMacAddress") String hubMacAddress){
        System.out.println("Reached retrieveActuatorMacAddress");
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        Map<String, Actuator> actuators = hub.getHubOwner().getOwnedActuators(); //Finds the actuator in the linked actuator list that is not active
        if (actuators.isEmpty()){
            return "No new actuators found";
        }
        else {
            for (String key : actuators.keySet()) {
                if (!(actuators.get(key).isActive())){
                    String actuatorMacAddress = actuators.get(key).getMacAddress();
                    System.out.println("New actuator Mac Address: " + actuatorMacAddress);
                    String actuatorType = actuators.get(key).getActuatorType().getName();
                    System.out.println("Actuator Type: " + actuatorType);
                    return actuatorMacAddress+","+actuatorType;
                }
            }
            return "No new actuators found";
        }
    }

    @GetMapping("/getThresholds")
    @ResponseBody
    public String getThresholds(@RequestParam("hubMacAddress") String hubMacAddress, @RequestParam(value="isStartUp", defaultValue = "true") String isStartUp){
        System.out.println("Reached getThresholds");
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        if (hub == null){
            return "Hub not found";
        }
        else if (hub.getHubOwner()==null){
            return "Hub owner not found";
        }
        else if (hub.getHubOwner().getOwnedSensors().isEmpty()){
            return "No sensors linked yet";
        }
        if (isStartUp.equals("true")) { //If it is starting up, then the hub seating start time should be set to 0
            float minutesFromLastRecord = (float) (LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - hub.getLastSeatingUpdate()) / 60;
            if ((minutesFromLastRecord > 10) && (hub.getSeatingStartTime() != 0)) { //Should match the value in /dashboard
                float newOccupancyRecordReading = Float.parseFloat(String.format("%.2f", ((hub.getLastSeatingUpdate() - hub.getSeatingStartTime()) / 60.0)));
                LocalDateTime datetime = LocalDateTime.ofEpochSecond(hub.getSeatingStartTime(), 0, ZoneOffset.ofHours(1)).toLocalDate().atStartOfDay();
                SensorType sensorType = sensorTypeService.findSensorTypeByName("Occupancy");
                SensorReading sensorReading = new SensorReading(hub.getHubOwner(), newOccupancyRecordReading, datetime, sensorType);
                sensorReadingService.saveSensorReading(sensorReading);
                hub.setSeatingStartTime(0);
                hubService.save(hub);
            }
        }

        //Creates command for hub
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("command", "103");
        JSONArray subJsonArray = new JSONArray();
        for (Sensor sensor: hub.getHubOwner().getOwnedSensors().values()){
            if (sensor.isAutomatePartnerActuatorBasedOnThresholds() || sensor.getSensorType().getName().equals("Occupancy") ){
                JSONObject subJsonObject = new JSONObject();
                subJsonObject.put("sensorTypeName", sensor.getSensorType().getName());
                subJsonObject.put("threshold", sensor.getThreshold());
                if (sensor.getSensorType().getPartnerActuatorType() != null){
                    subJsonObject.put("actuatorTypeName", sensor.getSensorType().getPartnerActuatorType().getName());
                }
                else{
                    subJsonObject.put("actuatorTypeName", "null");
                }
                subJsonArray.put(subJsonObject);
            }
        }
        jsonObject.put("message", subJsonArray);
        if (subJsonArray.isEmpty()){
            jsonObject.put("message", "null");
        }
        jsonArray.put(jsonObject);
        return jsonArray.toString();
    }

    //Live updates for actuator's state
    @PostMapping("/switchActuatorState")
    @ResponseBody
    public String switchActuatorState(@RequestParam("h") String hubMacAddress, @RequestParam("ActuatorType") String actuatorType, @RequestParam("state") String state){
        System.out.println("Reached switchActuatorState");
        Hub hub = hubService.findHubByMacAddress(hubMacAddress);
        if (hub == null){
            return "Hub not found";
        }
        Actuator actuator = actuatorService.findSpecificActuator(hub, actuatorType);
        if (actuator == null){
            return "Actuator not found";
        }
        if (state.equals("On")){
            actuatorService.turnOnActuator(actuator);
            return hubService.retrievePendingCommands(hub);
        }
        else if (state.equals("Off")){
           actuatorService.turnOffActuator(actuator);
            return hubService.retrievePendingCommands(hub);
        }
        else{
            return hubService.retrievePendingCommands(hub);
        }
    }
}
