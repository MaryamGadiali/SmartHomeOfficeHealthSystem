package com.example.officeFlow.model;

import jakarta.persistence.*;

@Entity
@Table(name = "actuatorType")
public class ActuatorType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "actuatorTypeId")
    private int actuatorTypeId;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @OneToOne
    @JoinColumn
    private SensorType partnerSensorType; //Always needs a partner sensor

    public int getActuatorTypeId() {
        return actuatorTypeId;
    }

    public void setActuatorTypeId(int actuatorTypeId) {
        this.actuatorTypeId = actuatorTypeId;
    }

    public SensorType getPartnerSensorType() {
        return partnerSensorType;
    }

    public void setPartnerSensorType(SensorType partnerSensorType) {
        this.partnerSensorType = partnerSensorType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}