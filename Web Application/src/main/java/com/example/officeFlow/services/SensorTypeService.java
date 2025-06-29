package com.example.officeFlow.services;

import com.example.officeFlow.model.SensorType;
import com.example.officeFlow.repositories.SensorTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SensorTypeService {

    @Autowired
    private SensorTypeRepository sensorTypeRepository;

    public void save(SensorType sensorType) {
        sensorTypeRepository.save(sensorType);
    }

    public List<SensorType> getAllSensorTypes() {
        return (List<SensorType>) sensorTypeRepository.findAll();
    }

    public SensorType findSensorTypeByName(String name) {
        return sensorTypeRepository.findSensorTypeByName(name);
    }
}
