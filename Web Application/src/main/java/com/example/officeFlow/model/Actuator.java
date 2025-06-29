package com.example.officeFlow.model;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "actuator")
public class Actuator {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "actuatorId")
    private int actuatorId;

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

    @Column(name = "lastUpdated")
    private LocalDateTime lastUpdated=null;

    @Column(name = "state")
    private boolean state = false;

    @ManyToOne
    @JoinColumn
    private User actuatorOwner;

    @ManyToOne
    @JoinColumn
    private ActuatorType actuatorType;

    @OneToOne(mappedBy = "partnerActuator")
    @JoinColumn
    private Sensor partnerSensor;

    // Getters and Setters
    public int getActuatorId() {
        return actuatorId;
    }

    public void setActuatorId(int actuatorId) {
        this.actuatorId = actuatorId;
    }

    public User getActuatorOwner() {
        return actuatorOwner;
    }

    public void setActuatorOwner(User actuatorOwner) {
        this.actuatorOwner = actuatorOwner;
    }

    public ActuatorType getActuatorType() {
        return actuatorType;
    }

    public void setActuatorType(ActuatorType actuatorType) {
        this.actuatorType = actuatorType;
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

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public boolean isState() {
        return state;
    }

    public void setState(boolean state) {
        this.state = state;
    }

    public Sensor getPartnerSensor() {
        return partnerSensor;
    }

    public void setPartnerSensor(Sensor partnerSensor) {
        this.partnerSensor = partnerSensor;
    }


}