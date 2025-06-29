package com.example.officeFlow.repositories;

import com.example.officeFlow.model.SensorType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SensorTypeRepository extends CrudRepository<SensorType, Integer> {

    SensorType findSensorTypeByName(String name);

}
