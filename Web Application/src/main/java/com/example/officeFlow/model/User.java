package com.example.officeFlow.model;

import jakarta.persistence.*;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "[user]")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userId")
    private int userId;

    @Column(name = "name")
    private String name;

    @Column(name = "email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "creationTimestamp")
    private LocalDateTime creationTimestamp;

    @Column(name = "dateOfBirth")
    private Date dateOfBirth;

    @OneToOne(mappedBy = "hubOwner")
    private Hub hub= null;

    @OneToMany(mappedBy = "sensorOwner",fetch = FetchType.EAGER)
    private Map<String, Sensor> ownedSensors = new HashMap<>();

    @OneToMany(mappedBy = "actuatorOwner")
    private Map<String, Actuator> ownedActuators = new HashMap<>();

    @OneToMany(mappedBy = "userRecipient")
    private List<Notification> notifications = new ArrayList<>();

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LocalDateTime getCreationTimestamp() {
        return creationTimestamp;
    }

    public void setCreationTimestamp(LocalDateTime creationTimestamp) {
        this.creationTimestamp = creationTimestamp;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Hub getHub() {
        return hub;
    }

    public void setHub(Hub hub) {
        this.hub = hub;
    }

    public Map<String, Sensor> getOwnedSensors() {
        return ownedSensors;
    }

    public void setOwnedSensors(Map<String, Sensor> ownedSensors) {
        this.ownedSensors = ownedSensors;
    }

    public Map<String, Actuator> getOwnedActuators() {
        return ownedActuators;
    }

    public void setOwnedActuators(Map<String, Actuator> ownedActuators) {
        this.ownedActuators = ownedActuators;
    }

    //Add to sensors list
    public void addSensor(Sensor sensor) {
        this.ownedSensors.put(sensor.getMacAddress(), sensor);
        System.out.println("Size of owned sensors in set method: " + ownedSensors.size());
    }

    public void removeSensor(Sensor sensor) {
        this.ownedSensors.remove(sensor.getMacAddress());
    }

    public void addActuator(Actuator actuator) {
        ownedActuators.put(actuator.getMacAddress(), actuator);
    }

    public void removeActuator(Actuator actuator) {
        ownedActuators.remove(actuator.getMacAddress());
    }

    public List<Notification> getNotifications() {
        return notifications;
    }

    public void setNotifications(List<Notification> notifications) {
        this.notifications = notifications;
    }
}