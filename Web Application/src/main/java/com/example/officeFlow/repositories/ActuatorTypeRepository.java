package com.example.officeFlow.repositories;

import com.example.officeFlow.model.ActuatorType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ActuatorTypeRepository extends CrudRepository<ActuatorType, Integer> {

    ActuatorType findActuatorTypeByName(String name);
}
