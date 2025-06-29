package com.example.officeFlow.repositories;

import com.example.officeFlow.model.Actuator;
import com.example.officeFlow.model.Hub;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ActuatorRepository extends CrudRepository<Actuator, Integer> {
    Actuator findByMacAddress(String macAddress);

    Actuator findByPairingCode(String pairingCode);

    Actuator findByActuatorOwner_HubAndActuatorType_Name(Hub actuatorOwnerHub, String actuatorTypeName);
}
