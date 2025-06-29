package com.example.officeFlow.controllers;

import com.example.officeFlow.model.*;
import com.example.officeFlow.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

/**
 * Controller for handling sensor and actuator
 */
@Controller
public class DeviceController {

    @Autowired
    private SensorTypeService sensorTypeService;

    @Autowired
    private UserService userService;

    @Autowired
    private HubService hubService;

    @Autowired
    private ActuatorService actuatorService;

    @Autowired
    private SensorService sensorService;

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

    /**
     * Displays the form for setting up a new hub
     *
     * @return the view for adding a new hub
     */
    @GetMapping("/addHub")
    public String addHub() {
        return "addHub";
    }


    /**
     * Called by the addHub jsp
     * Checks the validity of the entered hub pairing code
     *
     * @param hubCode - The pair code entered by the user
     * @return the outcome of the check in in a json formatted object.
     */
    @PostMapping("/verifyHubCode")
    @ResponseBody
    public Map<String, String> verifyHubCode(@RequestParam("hubCode") String hubCode) {
        Map<String, String> response = new HashMap<>();
        Hub hub = hubService.checkHubPairingCode(hubCode);

        if (hub == null) {
            System.out.println("Hub not found");
            response.put("Status", "Error");
            response.put("Message", "Hub not found");
        } else if (hub.isActive() && hub.getImplementationTimestamp() != null) {
            System.out.println("Hub is already in use");
            response.put("Status", "Error");
            response.put("Message", "Hub is already in use");
        } else {
            System.out.println("Hub found");
            response.put("Status", "Success");
            response.put("Message", "Valid code. Please turn on your hub to complete pairing");
            hub.setPairCodeUsed(true);
            hubService.save(hub);
        }
        return response;
    }

    /**
     * Is polled by the addHub jsp to check if the hub has connected to the application
     * which is signalled by the hub accessing /pairHub in HubController
     * which sets the hub to active in the database
     *
     * @param hubCode to identify the correct hub object
     * @return the status of the hub in a json formatted object
     */
    @GetMapping("/checkHubPairingResponse")
    @ResponseBody
    public Map<String, String> checkHubPairingResponse(@RequestParam("hubCode") String hubCode) {
        Map<String, String> response = new HashMap<>();
        Hub hub = hubService.checkHubPairingCode(hubCode);
        if (hub.isActive()) {
            response.put("Status", "Paired");
            response.put("Message", "Hub is now active");
        } else {
            response.put("Status", "Waiting");
            response.put("Message", "Hub is still inactive");
        }
        return response;
    }

    /**
     * After checkHubPairingResponse returns the active response,
     * the addHub jsp calls this to complete the hub and user details sync.
     *
     * @param hubCode to locate the hub object
     * @return The outcome of the syncing in a json formatted object
     */
    @PostMapping("/SyncUserAndHubDetails")
    @ResponseBody
    public Map<String, String> syncUserAndHubDetails(@RequestParam("hubCode") String hubCode) {
        Map<String, String> response = new HashMap<>();
        Hub hub = hubService.checkHubPairingCode(hubCode);
        User u = userService.findLoggedInUser();
        hubService.matchHubToUser(hub, u);
        userService.matchUserToHub(u, hub);

        response.put("Status", "Success");
        response.put("Message", "Hub and User details synced");
        return response;
    }

    /**
     * Called by dashboard jsp
     * Adds the actuator turn on/off command for the hub to later retrieve
     *
     * @param actuatorMacAddress - To locate the corresponding parent hub
     * @param command
     * @return "Success" once completed
     */
    @PostMapping("/addActuatorCommandForHub")
    @ResponseBody
    public String addActuatorCommandForHub(@RequestParam("actuatorMacAddress") String actuatorMacAddress, @RequestParam("command") String command) {
        Actuator targetActuator = actuatorService.findByMacAddress(actuatorMacAddress);
        Hub hub = targetActuator.getActuatorOwner().getHub();
        String targetActuatorType = targetActuator.getActuatorType().getName();
        if (command.equals("TurnOn")) {
            if (targetActuatorType.equals("Lamp")) {
                hub.addPendingCommand(102, "TurnOn");
            } else if (targetActuatorType.equals("Fan")) {
                hub.addPendingCommand(109, "TurnOn");
            }
            actuatorService.turnOnActuator(targetActuator);
        } else if (command.equals("TurnOff")) {
            if (targetActuatorType.equals("Lamp")) {
                hub.addPendingCommand(101, "TurnOff");
            } else if (targetActuatorType.equals("Fan")) {
                hub.addPendingCommand(110, "TurnOff");
            }
            actuatorService.turnOffActuator(targetActuator);
        }
        hubService.save(hub);
        return "Success";
    }


    /**
     * Returns the addDevice jsp for adding a new device to the network
     *
     * @param model - used to pass the following attributes to the jsp:
     *              unownedSensorType - To display adding options for the devices the user doesn't have
     *              ownedSensorsSize - Helps indicate if this is the user's first time adding a new sensor/actuator device
     * @return addDevice jsp
     */
    @RequestMapping("/setUpDevice")
    public String setUpDevice(Model model) {
        User user = userService.findLoggedInUser();
        List<SensorType> sensorTypes = sensorTypeService.getAllSensorTypes();

        for (Sensor ownedSensor : user.getOwnedSensors().values()) {
            if (sensorTypes.contains(ownedSensor.getSensorType())) {
                sensorTypes.remove(ownedSensor.getSensorType());
            }
        }
        model.addAttribute("unownedSensorType", sensorTypes);
        model.addAttribute("ownedSensorsSize", user.getOwnedSensors().size());
        return "addDevice";
    }

    @PostMapping("/removeDevicesFromUserNetwork") //Both sensor and actuator
    @ResponseBody
    public String removeDevicesFromUserNetwork(@RequestParam("sensorId") String sensorId) {
        System.out.println("Reached removeDevicesFromUserNetwork");
        sensorService.deleteDevicesFromNetwork(Integer.parseInt(sensorId));
        return "Success";
    }

    @PostMapping("/removeDeviceFromUserNetwork") //Singular unlinked sensor only (e.g. heart)
    @ResponseBody
    public String removeDeviceFromUserNetwork(@RequestParam("sensorId") String sensorId) {
        System.out.println("Reached removeDeviceFromUserNetwork");
        sensorService.deleteDeviceFromNetwork(Integer.parseInt(sensorId));
        return "Success";
    }

    @PostMapping("/removeCoreDevicesFromUserNetwork")
    @ResponseBody
    public String removeCoreDevicesFromUserNetwork(@RequestParam("hubId") String hubId) {
        sensorService.deleteCoreDevicesFromNetwork(hubId);
        return "Success";
    }

    @GetMapping("/setUpOccupancySensor")
    private String setUpOccupancySensor() {
        if (userService.findLoggedInUser().getHub() == null) {
            return "redirect:/addHub";
        }
        return "addOccupancySensor";
    }

    //This is called by the form in the addSeatingSensor jsp
    @PostMapping("/verifySeatingSensorCode")
    @ResponseBody
    public Map<String, String> verifySeatingSensorCode(@RequestParam("seatingSensorCode") String seatingSensorCode) {
        System.out.println("Reached verifySeatingSensorCode");
        Map<String, String> response = sensorService.verifySeatingSensorPairingCode(seatingSensorCode);
        System.out.println("Response: " + response);

        if (response.get("Status").equals("Success")) {
            User user = userService.findLoggedInUser();
            Hub hub = user.getHub();
            Sensor sensor = sensorService.findByPairingCode(seatingSensorCode);
            user.addSensor(sensor);
            sensor.setSensorOwner(user);
            sensorService.save(sensor);
            hubService.save(hub);
            userService.save(user);
        }
        return response;
    }

    //This will be called by the jsp repeatedly to see if the sensor has been set active
    @GetMapping("/checkIfHubSyncedWithSeatingSensor")
    @ResponseBody
    public Map<String, String> checkIfHubSyncedWithSeatingSensor(@RequestParam("seatingSensorCode") String seatingSensorCode) {
        System.out.println("Reached checkIfHubSyncedWithSeatingSensor");
        Map<String, String> response = new HashMap<>();
        Sensor sensor = sensorService.findByPairingCode(seatingSensorCode);
        System.out.println("Sensor Active: " + sensor.isActive());
        if (sensor.isActive()) {
            response.put("Status", "Success");
            response.put("Message", "Seating sensor synced successfully");
        } else {
            response.put("Status", "Waiting");
            response.put("Message", "No updates seen yet");
        }
        return response;
    }

    @PostMapping("/verifySensorPairCode")
    @ResponseBody
    public Map<String, String> verifySensorPairCode(@RequestParam("sensorPairCode") String sensorPairCode, @RequestParam("sensorTypeName") String sensorTypeName) {
        System.out.println("Reached verifySensorPairCode");
        Map<String, String> response = sensorService.verifySensorPairingCode(sensorPairCode, sensorTypeName);
        System.out.println("Response: " + response);

        if (response.get("Status").equals("Success")) {
            User user = userService.findLoggedInUser();
            Hub hub = user.getHub();
            Sensor sensor = sensorService.findByPairingCode(sensorPairCode);
            user.addSensor(sensor);
            sensor.setSensorOwner(user);
            hub.addPendingCommand(111, "Start add new device process");
            sensorService.save(sensor);
            hubService.save(hub);
            userService.save(user);
        }
        return response;
    }


    //This will be called by the addDevice jsp repeatedly to see if the sensor has been set active by the hub
    @GetMapping("/checkIfHubSyncedWithSensor")
    @ResponseBody
    public Map<String, String> checkIfHubSyncedWithSensor(@RequestParam("sensorPairCode") String sensorPairCode) {
        System.out.println("Reached checkIfHubSyncedWithSensor");
        Map<String, String> response = new HashMap<>();
        Sensor sensor = sensorService.findByPairingCode(sensorPairCode);
        System.out.println("Sensor Active: " + sensor.isActive());
        if (sensor.isActive()) {
            response.put("Status", "Success");
            response.put("Message", "Sensor synced successfully");
        } else {
            response.put("Status", "Waiting");
            response.put("Message", "No updates seen yet");
        }
        return response;
    }

//    @GetMapping("/createError")
//    public String causeError() {
//        throw new RuntimeException("Test error for logging file");
//    }

    @PostMapping("/verifyActuatorPairCode")
    @ResponseBody
    public Map<String, String> verifyActuatorPairCode(@RequestParam("actuatorPairCode") String actuatorPairCode, @RequestParam("actuatorTypeName") String actuatorTypeName) {
        System.out.println("Reached verifyActuatorPairCode");
        Map<String, String> response = actuatorService.verifyActuatorPairingCode(actuatorPairCode, actuatorTypeName);
        System.out.println("Response: " + response);

        if (response.get("Status").equals("Success")) {
            User user = userService.findLoggedInUser();
            Hub hub = user.getHub();
            Actuator actuator = actuatorService.findByPairingCode(actuatorPairCode);
            user.addActuator(actuator);
            actuator.setActuatorOwner(user);
            actuatorService.save(actuator);
            hubService.save(hub);
            userService.save(user);
        }
        return response;
    }


    //This will be called by the addDevice jsp repeatedly to see if the actuator has been set active by the hub
    @GetMapping("/checkIfHubSyncedWithActuator")
    @ResponseBody
    public Map<String, String> checkIfHubSyncedWithActuator(@RequestParam("actuatorPairCode") String actuatorPairCode) {
        System.out.println("Reached checkIfHubSyncedWithActuator");
        Map<String, String> response = new HashMap<>();
        Actuator actuator = actuatorService.findByPairingCode(actuatorPairCode);
        System.out.println("Actuator Active: " + actuator.isActive());
        if (actuator.isActive()) {
            String partnerSensorType = actuator.getActuatorType().getPartnerSensorType().getName();
            Hub hub = actuator.getActuatorOwner().getHub();
            System.out.println("Hub linked sensors: " + hub.getHubOwner().getOwnedSensors());
            System.out.println("Hub linked sensor size " + hub.getHubOwner().getOwnedSensors().size());
            Sensor partnerSensor = sensorService.findSpecificSensor(hub, partnerSensorType);
            partnerSensor.setPartnerActuator(actuator);
            actuator.setPartnerSensor(partnerSensor);
            sensorService.save(partnerSensor);
            actuatorService.save(actuator);

            response.put("Status", "Success");
            response.put("Message", "Actuator synced successfully");
        } else {
            response.put("Status", "Waiting");
            response.put("Message", "No updates seen yet");
        }
        return response;
    }

}
