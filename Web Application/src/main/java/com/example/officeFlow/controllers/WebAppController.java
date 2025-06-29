package com.example.officeFlow.controllers;

import com.example.officeFlow.model.*;
import com.example.officeFlow.services.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Controller
public class WebAppController {

    @Autowired
    private UserService userService;

    @Autowired
    private SensorReadingService sensorReadingService;

    @Autowired
    private SensorService sensorService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private HubService hubService;

    @Autowired
    private ActuatorService actuatorService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private SensorTypeService sensorTypeService;

    /**
     * A passable attribute to all connected jsps in this controller
     * Identifies who the active user is to show on the navbar
     *
     * @return 401 error if user cannot be identified, or the user's name.
     */
    @ModelAttribute("userName")
    public String getCurrentUserName() {
        String currentUser = userService.getCurrentUserName();
        if (currentUser == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Unauthorized"); //401
        } else {
            return currentUser;
        }
    }

    @RequestMapping("/accessDenied")
    public String accessDenied() {
        return "accessDenied";
    }

    @RequestMapping(value = {"/dashboard", "/"})
    public String dashboard(Model model) {
        User user = userService.findLoggedInUser();
        if (user.getEmail().equals("admin@admin")) { //Admin redirects to API
            return "redirect:/swagger-ui/index.html";
        }

        boolean hasHub = user.getHub() != null;
        Hub hub = user.getHub();
        model.addAttribute("hasHub", hasHub);
        boolean hasReadings = sensorReadingService.hasReadingsForUser(user);
        model.addAttribute("hasReadings", hasReadings); //To check if user used to have a device network, but no longer does
        boolean hasPastData = sensorReadingService.hasPastDataForUser(user); //This is for older than a day
        model.addAttribute("hasPastData", hasPastData);

        model.addAttribute("amountOfSensors", user.getOwnedSensors().size());
        if (user.getOwnedSensors().size() > 0 && hasHub) {
            for (Sensor ownedSensor : user.getOwnedSensors().values()) {
                String sensorTypeName = ownedSensor.getSensorType().getName();
                if (sensorTypeName.equals("Occupancy")) {
                    //If it has been more than 10 minutes from the last seating update, then the devices is considered shut off,
                    // and a new record is made from the start time until the last seating record time, and then the start time is set to 0
                    float minutesFromLastRecord = (float) (LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - hub.getLastSeatingUpdate()) / 60;
                    if ((minutesFromLastRecord > 10) && (hub.getSeatingStartTime() != 0)) {
                        float newOccupancyRecordReading = Float.parseFloat(String.format("%.2f", ((hub.getLastSeatingUpdate() - hub.getSeatingStartTime()) / 60.0)));
                        if (newOccupancyRecordReading == 1 || newOccupancyRecordReading == 1f) { //Found float bug where if value is exactly 1, it acts unexpectedly and shows big values
                            newOccupancyRecordReading = 1.1f;
                        }
                        LocalDateTime datetime = LocalDateTime.ofEpochSecond(hub.getSeatingStartTime(), 0, ZoneOffset.ofHours(1)).toLocalDate().atStartOfDay();
                        SensorType sensorType = sensorTypeService.findSensorTypeByName("Occupancy");
                        SensorReading sensorReading = new SensorReading(user, newOccupancyRecordReading, datetime, sensorType);
                        sensorReadingService.saveSensorReading(sensorReading);
                        hub.setSeatingStartTime(0);
                        hubService.save(hub);

                    } else if (hub.getSeatingStartTime() != 0) { //If the user is present, then there is ongoing session
                        float ongoingOccupancyTime = Float.parseFloat(String.format("%.2f", ((LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - hub.getSeatingStartTime()) / 60.0)));
                        model.addAttribute("ongoingOccupancyTime", ongoingOccupancyTime);
                    }
                }
                //Today's readings
                model.addAttribute(sensorTypeName + "Today", sensorReadingService.getAllReadingsOfTypeForUserForToday(hub, ownedSensor.getSensorType().getName()));
            }
        } else {
            System.out.println("User does not have enough sensors to display readings");
        }

        //Passes in user's actuators
        for (Actuator ownedActuator : user.getOwnedActuators().values()) {
            System.out.println("Actuator type name: " + ownedActuator.getActuatorType().getName());
            model.addAttribute(ownedActuator.getActuatorType().getName(), ownedActuator);
        }
        return "dashboard";
    }

    @RequestMapping("/thresholdSettings")
    public String thresholdSettings(Model model) {
        model.addAttribute("sensors", userService.findLoggedInUser().getOwnedSensors().values());
        return "thresholdSettings";
    }

    @PostMapping("/updateThreshold")
    @ResponseBody
    public String updateThreshold(@RequestParam("sensorId") String sensorId, @RequestParam("newThresholdValue") float newThresholdValue, Model model) {
        Sensor sensor = sensorService.findBySensorId(Integer.parseInt(sensorId));
        sensor.setThreshold(newThresholdValue);
        sensorService.save(sensor);
        //Uses command 105 to update a specific threshold key, if the automation is enabled for it (or is occupancy)
        if (sensor.isAutomatePartnerActuatorBasedOnThresholds() || sensor.getSensorType().getName().equals("Occupancy")) {
            Hub hub = sensor.getSensorOwner().getHub();
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("sensorTypeName", sensor.getSensorType().getName());
            jsonObject.put("threshold", sensor.getThreshold());
            if (sensor.getPartnerActuator() != null) {
                jsonObject.put("actuatorTypeName", sensor.getPartnerActuator().getActuatorType().getName());
            } else {
                jsonObject.put("actuatorTypeName", "null");
            }
            hub.addPendingCommand(105, jsonObject);
            hubService.save(hub);
        }
        return "Success";
    }

    @GetMapping("/checkNotification")
    @ResponseBody
    public String checkUserNotification() {
        User user = userService.findLoggedInUser();
        return notificationService.findEarliestUnreadNotification(user);
    }

    //When user clicks to enable/disable automation in threshold settings
    @PostMapping("/switchAutomationState")
    @ResponseBody
    public String switchAutomationState(@RequestParam("sensorId") String sensorId, @RequestParam("state") boolean state) {
        Sensor sensor = sensorService.findBySensorId(Integer.parseInt(sensorId));
        sensor.setAutomatePartnerActuatorBasedOnThresholds(state);
        sensorService.save(sensor);

        //104 to remove threshold -Send the string key of sensor type
        //105 to add/update - Sends key details, e.g. : {sensorTypeName:Light, thresholdMin:500.0, actuatorTypeName:Lamp}
        Hub hub = sensor.getSensorOwner().getHub();
        if (!state) {
            hub.addPendingCommand(104, sensor.getSensorType().getName());
            hubService.save(hub);
        } else {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("sensorTypeName", sensor.getSensorType().getName());
            jsonObject.put("threshold", sensor.getThreshold());
            jsonObject.put("actuatorTypeName", sensor.getPartnerActuator().getActuatorType().getName());

            hub.addPendingCommand(105, jsonObject);
            hubService.save(hub);
        }
        return "Success";
    }

    //When user clicks to enable/disable notifications in threshold settings
    @PostMapping("switchNotificationState")
    @ResponseBody
    public String switchNotificationState(@RequestParam("sensorId") String sensorId, @RequestParam("state") boolean state) {
        Sensor sensor = sensorService.findBySensorId(Integer.parseInt(sensorId));
        sensor.setShowNotifications(state);
        sensorService.save(sensor);
        return "Success";
    }

    @GetMapping("/faq")
    public String faq(Model model) {
        return "faq";
    }

    @GetMapping("/checkActuatorState")
    @ResponseBody
    public boolean checkActuatorState(@RequestParam("actuatorAddress") String actuatorAddress) {
        Actuator actuator = actuatorService.findByMacAddress(actuatorAddress);
        if (actuator == null) {
            return false;
        }
        //If the actuator is set as active but has not received a status update in the last 3 minutes, then it is considered off
        if (actuator.isState() && ((LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - actuator.getLastUpdated().toEpochSecond(ZoneOffset.ofHours(1))) > 180)) { //3 minutes
            actuatorService.turnOffActuator(actuator);
        }
        return actuator.isState();
    }

    @GetMapping("/accountSettings")
    public String accountSettings(Model model) {
        model.addAttribute("user", userService.findLoggedInUser());
        return "accountSettings";
    }

    @GetMapping("/manageDevices")
    public String manageDevices(Model model, @RequestParam(value = "removal", defaultValue = "false") String removal) {
        User user = userService.findLoggedInUser();
        model.addAttribute("hub", user.getHub());
        model.addAttribute("sensors", user.getOwnedSensors().values());
        model.addAttribute("actuators", user.getOwnedActuators().values());

        if (removal.equals("true")) {
            model.addAttribute("removal", true);
        }
        return "manageDevices";
    }

    @PostMapping("/updateAccountDetail")
    @ResponseBody
    public String updateAccountDetail(@RequestParam("accountDetail") String accountDetailType, @RequestParam("newValue") String newValue) {
        System.out.println("Update account details method reached");
        User user = userService.findLoggedInUser();

        if (accountDetailType.equals("name")) {
            System.out.println("Name updating");
            user.setName(newValue);
        } else if (accountDetailType.equals("email")) {
            System.out.println("email updating");
            user.setEmail(newValue);
        } else if (accountDetailType.equals("password")) {
            System.out.println("password updating");
            user.setPassword(passwordEncoder.encode(newValue));
        } else if (accountDetailType.equals("dateOfBirth")) {
            System.out.println("dateOfBirth updating");
            user.setDateOfBirth(Date.valueOf(newValue));
        }
        userService.save(user);
        UserDetails userDetails = userService.loadUserByUsername(user.getEmail());
        UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(auth);
        return "Success";
    }

    @GetMapping("/getPastData")
    @ResponseBody
    public String getPastData(@RequestParam("option") String option, @RequestParam("type") String type, @RequestParam(value = "startDate", defaultValue = "-1") String startDate, @RequestParam(value = "endDate", defaultValue = "-1") String endDate) {
        User user = userService.findLoggedInUser();
        String result = "";
        if (startDate.equals("-1")) {
            if (type.equals("Light") || type.equals("Heart")) {
                result = sensorReadingService.getHistReadingsPerHourForNumDays(user, option, type);
            } else if (type.equals("Temperature") || type.equals("Occupancy")) { //Grouped values by day
                result = sensorReadingService.getHistReadingsPerDayForNumDays(user, option, type);
            }
        } else {
            if (type.equals("Light") || type.equals("Heart")) { //Grouped values by hours of the day
                result = sensorReadingService.getHistReadingsPerHourForCustomRange(user, option, type, startDate, endDate);
            } else if (type.equals("Temperature") || type.equals("Occupancy")) {
                result = sensorReadingService.getHistReadingsPerDayForCustomRange(user, option, type, startDate, endDate);
            }
        }
        if (result.isEmpty() || result.equals("{}")) {
            return "null";
        }
        return result;
    }

    @PostMapping("/deleteAccount")
    @ResponseBody
    public String deleteAccount() {
        userService.deleteAccount();
        return "Success";
    }

    @PostMapping("/resetHubWifi")
    @ResponseBody
    public String resetHubWifi() {
        Hub hub = userService.findLoggedInUser().getHub();
        hub.addPendingCommand(112, "Reset wifi details");
        hubService.save(hub);
        return "Success";
    }

    @PostMapping("/checkCurrentPassword")
    @ResponseBody
    public String checkCurrentPassword(@RequestParam("currentPassword") String currentPassword) {
        System.out.println("Check current password method reached");
        User user = userService.findLoggedInUser();
        if (passwordEncoder.matches(currentPassword, user.getPassword())) {
            System.out.println("Password matches");
            return "True";
        } else {
            System.out.println("Password does not match");
            return "False";
        }
    }

    @GetMapping("/about")
    public String about(Model model) {
        return "about";
    }
}

