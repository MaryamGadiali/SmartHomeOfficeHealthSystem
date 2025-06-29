package com.example.officeFlow.services;

import com.example.officeFlow.model.*;
import com.example.officeFlow.repositories.SensorRepository;
import com.example.officeFlow.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class SensorService {

    @Autowired
    private SensorRepository sensorRepository;

    @Autowired
    private ActuatorService actuatorService;

    @Autowired
    private HubService hubService;

    @Autowired
    private UserRepository userRepository;

    public Map<String, String> verifySeatingSensorPairingCode(String seatingSensorCode) { //In future, should merge with verify sensorpaircode
        Map<String, String> response = new HashMap<>();
        Sensor sensor = sensorRepository.findByPairingCode(seatingSensorCode);
        if (sensor != null) {
            if ((sensor.getSensorType().getName()).equals("Occupancy")) {
                if (sensor.isActive()) {
                    response.put("Status", "Error");
                    response.put("Message", "Sensor already active");
                } else {
                    response.put("Status", "Success");
                    response.put("Message", "Valid Sensor");
                }
                return response;
            } else {
                System.out.println("Invalid Sensor Type");
                System.out.println(sensor.getSensorType().getName());
                response.put("Status", "Error");
                response.put("Message", "Invalid Code");
                return response;
            }
        } else {
            response.put("Status", "Error");
            response.put("Message", "Invalid Code");
            return response;
        }
    }

    public Map<String, String> verifySensorPairingCode(String sensorCode, String sensorTypeName) {
        Map<String, String> response = new HashMap<>();
        Sensor sensor = sensorRepository.findByPairingCode(sensorCode);
        if (sensor != null) {
            if ((sensor.getSensorType().getName()).equals(sensorTypeName)) {
                if (sensor.isActive()) {
                    response.put("Status", "Error");
                    response.put("Message", "Sensor already active");
                } else { //Don't need to be strict on if pair code is used yet or not
                    response.put("Status", "Success");
                    response.put("Message", "Valid Sensor");
                }
                return response;
            } else {
                System.out.println("Invalid Sensor Type");
                System.out.println(sensor.getSensorType().getName());
                response.put("Status", "Error");
                response.put("Message", "Invalid Code");
                return response;
            }
        } else {
            response.put("Status", "Error");
            response.put("Message", "Invalid Code");
            return response;
        }
    }

    public void save(Sensor sensor1) {
        sensorRepository.save(sensor1);
    }

    public Sensor findByPairingCode(String seatingSensorCode) {
        return sensorRepository.findByPairingCode(seatingSensorCode);
    }

    public Sensor findByMacAddress(String seatingSensorMacAddress) {
        return sensorRepository.findByMacAddress(seatingSensorMacAddress);
    }

    public Sensor findBySensorId(int sensorId) {
        return sensorRepository.findBySensorId(sensorId);
    }

    public Sensor findSpecificSensor(Hub hub, String sensorTypeName) {
        return sensorRepository.findBySensorOwner_HubAndSensorType_Name(hub, sensorTypeName);
    }

    public void deleteDevicesFromNetwork(int sensorId) {
        Sensor sensor = findBySensorId(sensorId);
        User user = sensor.getSensorOwner();
        Hub hub = sensor.getSensorOwner().getHub();
        SensorType sensorType = sensor.getSensorType();
        sensor.setImplementationTimestamp(null);
        sensor.setRemovalTimestamp(LocalDateTime.now());
        sensor.setActive(false);
        sensor.setSensorOwner(null);
        sensor.setThreshold(sensorType.getDefaultThreshold()); //Resetting it back
        sensor.setAutomatePartnerActuatorBasedOnThresholds(false);
        Actuator actuator = sensor.getPartnerActuator();
        actuator.setImplementationTimestamp(null);
        actuator.setRemovalTimestamp(LocalDateTime.now());
        actuator.setActive(false);
        actuator.setActuatorOwner(null);
        actuator.setState(false);
        sensor.setPartnerActuator(null);
        actuator.setPartnerSensor(null);

        user.removeSensor(sensor);
        user.removeActuator(actuator);

        hub.addPendingCommand(106, sensorType.getName());
        hub.addPendingCommand(107, actuator.getActuatorType().getName());

        sensorRepository.save(sensor);
        actuatorService.save(actuator);
        hubService.save(hub);
        userRepository.save(user);
    }

    public void deleteDeviceFromNetwork(int sensorId) {
        Sensor sensor = findBySensorId(sensorId);
        User user = sensor.getSensorOwner();
        Hub hub = sensor.getSensorOwner().getHub();
        SensorType sensorType = sensor.getSensorType();
        sensor.setImplementationTimestamp(null);
        sensor.setRemovalTimestamp(LocalDateTime.now());
        sensor.setActive(false);
        sensor.setSensorOwner(null);
        sensor.setThreshold(sensorType.getDefaultThreshold()); //Resetting it back
        sensor.setAutomatePartnerActuatorBasedOnThresholds(false);
        sensor.setPartnerActuator(null);
        user.removeSensor(sensor);

        hub.addPendingCommand(106, sensorType.getName());

        sensorRepository.save(sensor);
        hubService.save(hub);
        userRepository.save(user);
    }


    public void deleteCoreDevicesFromNetwork(String hubId) {
        Hub hub = hubService.findHubByMacAddress(hubId);
        Sensor occupancy = hub.getHubOwner().getOwnedSensors().values().iterator().next();
        SensorType sensorType = occupancy.getSensorType();
        User user = hub.getHubOwner();

        hub.setImplementationTimestamp(null);
        hub.setRemovalTimestamp(LocalDateTime.now());
        hub.setActive(false);
        hub.setPairCodeUsed(false);
        hub.setSeatingStartTime(0);
        hub.setLastSeatingUpdate(0);
        hub.setHubOwner(null);

        occupancy.setSensorOwner(null);
        occupancy.setImplementationTimestamp(null);
        occupancy.setRemovalTimestamp(LocalDateTime.now());
        occupancy.setActive(false);
        occupancy.setThreshold(sensorType.getDefaultThreshold());
        occupancy.setAutomatePartnerActuatorBasedOnThresholds(false);
        occupancy.setPartnerActuator(null);

        user.setHub(null);
        user.removeSensor(occupancy);
        user.setNotifications(null);

        hub.addPendingCommand(106, sensorType.getName());
        hub.addPendingCommand(108, "Restart");

        hubService.save(hub);
        save(occupancy);
        userRepository.save(user);
    }

    public String getPairingCode(String macAddress) {
        return sensorRepository.findByPairingCode(macAddress).getPairingCode();
    }
}
