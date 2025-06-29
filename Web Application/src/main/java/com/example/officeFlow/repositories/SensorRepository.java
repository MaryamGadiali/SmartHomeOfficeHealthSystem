package com.example.officeFlow.repositories;

import com.example.officeFlow.model.Hub;
import com.example.officeFlow.model.Sensor;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SensorRepository extends CrudRepository<Sensor, Integer> {
    Sensor findByPairingCode(String pairingCode);

    Sensor findByMacAddress(String macAddress);

    Sensor findBySensorId(int sensorId);

    Sensor findBySensorOwner_HubAndSensorType_Name(Hub sensorOwnerHub, String sensorTypeName);

}
