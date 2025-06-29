package com.example.officeFlow.model;

import jakarta.persistence.*;

@Entity
@Table(name = "sensorType")
public class SensorType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sensorTypeId")
    private int sensorTypeId;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "unit")
    private String unit;

    @Column(name = "defaultThreshold")
    private float defaultThreshold;

    @OneToOne
    @JoinColumn
    private ActuatorType partnerActuatorType = null;

    public int getSensorTypeId() {
        return sensorTypeId;
    }

    public void setSensorTypeId(int sensorTypeId) {
        this.sensorTypeId = sensorTypeId;
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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public ActuatorType getPartnerActuatorType() {
        return partnerActuatorType;
    }

    public void setPartnerActuatorType(ActuatorType partnerActuatorType) {
        this.partnerActuatorType = partnerActuatorType;
    }

    public float getDefaultThreshold() {
        return defaultThreshold;
    }

    public void setDefaultThreshold(float defaultThreshold) {
        this.defaultThreshold = defaultThreshold;
    }
}