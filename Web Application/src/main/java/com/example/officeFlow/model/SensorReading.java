package com.example.officeFlow.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sensorReading")
public class SensorReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sensorReadingId")
    private int sensorReadingId;

    @Column(name = "value")
    private float value;

    @Column(name = "timestamp")
    private LocalDateTime timestamp;

    @ManyToOne
    @JoinColumn
    private User user;

    @ManyToOne
    @JoinColumn
    private SensorType type;

    public SensorReading(User user, float value, LocalDateTime timestamp, SensorType type) {
        this.user = user;
        this.value = value;
        this.timestamp = timestamp;
        this.type = type;
    }

    public SensorReading() {}

    public int getSensorReadingId() {
        return sensorReadingId;
    }

    public void setSensorReadingId(int sensorReadingId) {
        this.sensorReadingId = sensorReadingId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public SensorType getType() {
        return type;
    }

    public void setType(SensorType type) {
        this.type = type;
    }

    public float getValue() {
        return value;
    }

    public void setValue(float value) {
        this.value = value;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}