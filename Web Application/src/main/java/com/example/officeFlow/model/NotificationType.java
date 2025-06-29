package com.example.officeFlow.model;
import jakarta.persistence.*;

@Entity
@Table(name = "notificationType")
public class NotificationType {

    @Id
    @Column(name = "notificationTypeId")
    private int notificationTypeId;

    @Column(name = "message")
    private String message;

    public int getNotificationTypeId() {
        return notificationTypeId;
    }

    public void setNotificationTypeId(int notificationTypeId) {
        this.notificationTypeId = notificationTypeId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
