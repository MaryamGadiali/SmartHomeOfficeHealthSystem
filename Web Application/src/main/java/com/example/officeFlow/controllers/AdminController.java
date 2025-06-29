package com.example.officeFlow.controllers;

import com.example.officeFlow.model.*;
import com.example.officeFlow.services.*;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private HubService hubService;

    @Autowired
    private SensorService sensorService;

    @Autowired
    private ActuatorService actuatorService;

    @Autowired
    private SensorTypeService sensorTypeService;

    @Autowired
    private ActuatorTypeService actuatorTypeService;

    @PostMapping("/addNewHubToDatabase")
    @ResponseBody
    public String addNewHubToDatabase(@RequestParam("macAddress") String macAddress) {
        Hub newHub = new Hub();
        newHub.setActive(false);
        newHub.setPairCodeUsed(false);
        newHub.setHubMacAddress(macAddress);
        newHub.setPairingCode(RandomStringUtils.randomAlphanumeric(6));
        hubService.save(newHub);
        return newHub.getPairingCode();
    }
    @PostMapping("/addNewSensorToDatabase")
    @ResponseBody
    public String addNewSensorToDatabase(@RequestParam("macAddress") String macAddress, @RequestParam("sensorType") String sensorType) {
        SensorType sensorTypeObj = sensorTypeService.findSensorTypeByName(sensorType);
        if (sensorTypeObj == null) {
            return "Invalid sensor type";
        }
        Sensor newSensor = new Sensor();
        newSensor.setActive(false);
        newSensor.setMacAddress(macAddress);
        newSensor.setPairingCode(RandomStringUtils.randomAlphanumeric(6));
        newSensor.setSensorType(sensorTypeObj);
        newSensor.setThreshold(sensorTypeObj.getDefaultThreshold());
        sensorService.save(newSensor);
        return newSensor.getPairingCode();
    }
    @PostMapping("/addNewActuatorToDatabase")
    @ResponseBody
    public String addNewActuatorToDatabase(@RequestParam("macAddress") String macAddress, @RequestParam("actuatorType") String actuatorType) {
        ActuatorType actuatorTypeObj = actuatorTypeService.findActuatorTypeByName(actuatorType);
        if (actuatorTypeObj == null) {
            return "Invalid actuator type";
        }
        Actuator newActuator = new Actuator();
        newActuator.setActive(false);
        newActuator.setMacAddress(macAddress);
        newActuator.setPairingCode(RandomStringUtils.randomAlphanumeric(6));
        actuatorService.save(newActuator);
        return newActuator.getPairingCode();
    }

    @GetMapping("/getPairingCodeForDevice")
    @ResponseBody
    public String getPairingCodeForDevice(@RequestParam("macAddress") String macAddress, @RequestParam("deviceType") String deviceType) {

        if (deviceType.equals("hub")) {
            return hubService.getPairingCode(macAddress);
        }
        if (deviceType.equals("sensor")) {
            return sensorService.getPairingCode(macAddress);
        }
        else if (deviceType.equals("actuator")) {
            return actuatorService.getPairingCode(macAddress);
        }
        else {
            return "Invalid device type";
        }
    }

}
