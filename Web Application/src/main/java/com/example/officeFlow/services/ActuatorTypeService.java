package com.example.officeFlow.services;

import com.example.officeFlow.model.ActuatorType;
import com.example.officeFlow.repositories.ActuatorTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActuatorTypeService {

    @Autowired
    private ActuatorTypeRepository actuatorTypeRepository;

    public void save(ActuatorType actuatorType) {
        actuatorTypeRepository.save(actuatorType);
    }

    public ActuatorType findActuatorTypeByName(String actuatorTypeName) {
        return actuatorTypeRepository.findActuatorTypeByName(actuatorTypeName);
    }
}
