package com.example.officeFlow.services;

import com.example.officeFlow.model.Actuator;
import com.example.officeFlow.model.Hub;
import com.example.officeFlow.repositories.ActuatorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class ActuatorService {

    @Autowired
    private ActuatorRepository actuatorRepository;

    public Actuator findByMacAddress(String hubMacAddress) {
        return actuatorRepository.findByMacAddress(hubMacAddress);
    }

    public void save(Actuator targetActuator) {
        actuatorRepository.save(targetActuator);
    }

    public Actuator findByPairingCode(String actuatorCode) {
        return actuatorRepository.findByPairingCode(actuatorCode);
    }

    public Map<String, String> verifyActuatorPairingCode(String actuatorCode, String actuatorTypeName) {
        Map<String, String> response = new HashMap<>();
        Actuator actuator = actuatorRepository.findByPairingCode(actuatorCode);

        if (actuator != null) {
            if ((actuator.getActuatorType().getName()).equals(actuatorTypeName)) {
                if (actuator.isActive()) {
                    response.put("Status", "Error");
                    response.put("Message", "Actuator already active");
                } else {
                    response.put("Status", "Success");
                    response.put("Message", "Valid Actuator");
                }
                return response;
            } else {
                System.out.println("Invalid Actuator Type");
                System.out.println(actuator.getActuatorType().getName());
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

    public void turnOffActuator(Actuator targetActuator) {
        targetActuator.setState(false);
        targetActuator.setLastUpdated(null);
        actuatorRepository.save(targetActuator);
    }

    public void turnOnActuator(Actuator targetActuator) {
        targetActuator.setState(true);
        targetActuator.setLastUpdated(LocalDateTime.now());
        actuatorRepository.save(targetActuator);
    }

    public Actuator findSpecificActuator(Hub hub, String actuatorType) {
        return actuatorRepository.findByActuatorOwner_HubAndActuatorType_Name(hub, actuatorType);
    }

    public String getPairingCode(String macAddress) {
        return actuatorRepository.findByMacAddress(macAddress).getPairingCode();
    }
}