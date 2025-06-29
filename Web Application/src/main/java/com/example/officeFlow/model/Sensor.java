package com.example.officeFlow.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sensor")
public class Sensor{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sensorId")
    private int sensorId;

    @Column(name = "macAddress")
    private String macAddress;

    @Column(name = "pairingCode")
    private String pairingCode;

    @Column(name = "implementationTimestamp")
    private LocalDateTime implementationTimestamp;

    @Column(name = "removalTimestamp")
    private LocalDateTime removalTimestamp;

    @Column(name = "isActive")
    private boolean isActive;

    @Column(name = "threshold")
    private float threshold = -1;

    @Column
    private boolean automatePartnerActuatorBasedOnThresholds = false;

    @Column(name = "showNotifications")
    private boolean showNotifications = true;

    @ManyToOne
    @JoinColumn
    private User sensorOwner;

    @ManyToOne
    @JoinColumn
    private SensorType sensorType;

    @OneToOne
    private Actuator partnerActuator = null;

    public int getSensorId() {
        return sensorId;
    }

    public void setSensorId(int sensorId) {
        this.sensorId = sensorId;
    }

    public User getSensorOwner() {
        return sensorOwner;
    }

    public void setSensorOwner(User sensorOwner) {
        this.sensorOwner = sensorOwner;
    }

    public SensorType getSensorType() {
        return sensorType;
    }

    public void setSensorType(SensorType sensorType) {
        this.sensorType = sensorType;
    }

    public String getMacAddress() {
        return macAddress;
    }

    public void setMacAddress(String macAddress) {
        this.macAddress = macAddress;
    }

    public String getPairingCode() {
        return pairingCode;
    }

    public void setPairingCode(String pairingCode) {
        this.pairingCode = pairingCode;
    }

    public LocalDateTime getImplementationTimestamp() {
        return implementationTimestamp;
    }

    public void setImplementationTimestamp(LocalDateTime implementationTimestamp) {
        this.implementationTimestamp = implementationTimestamp;
    }

    public LocalDateTime getRemovalTimestamp() {
        return removalTimestamp;
    }

    public void setRemovalTimestamp(LocalDateTime removalTimestamp) {
        this.removalTimestamp = removalTimestamp;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public float getThreshold() {
        return threshold;
    }

    public void setThreshold(float threshold) {
        this.threshold = threshold;
    }

    public Actuator getPartnerActuator() {
        return partnerActuator;
    }

    public void setPartnerActuator(Actuator partnerActuator) {
        this.partnerActuator = partnerActuator;
    }

    public boolean isAutomatePartnerActuatorBasedOnThresholds() {
        return automatePartnerActuatorBasedOnThresholds;
    }

    public void setAutomatePartnerActuatorBasedOnThresholds(boolean automatePartnerActuatorBasedOnThresholds) {
        this.automatePartnerActuatorBasedOnThresholds = automatePartnerActuatorBasedOnThresholds;
    }

    public boolean isShowNotifications() {
        return showNotifications;
    }

    public void setShowNotifications(boolean showNotifications) {
        this.showNotifications = showNotifications;
    }
}
