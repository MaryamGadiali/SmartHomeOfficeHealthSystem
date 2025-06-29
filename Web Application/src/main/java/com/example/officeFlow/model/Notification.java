package com.example.officeFlow.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "[notification]")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notificationId")
    private int notificationId;

    @Column(name = "timestamp")
    private LocalDateTime timestamp;

    @Column(name = "hasBeenDisplayed")
    private boolean hasBeenDisplayed = false;

    @ManyToOne
    private NotificationType notificationType;

    @ManyToOne
    private User userRecipient;

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public boolean isHasBeenDisplayed() {
        return hasBeenDisplayed;
    }

    public void setHasBeenDisplayed(boolean hasBeenDisplayed) {
        this.hasBeenDisplayed = hasBeenDisplayed;
    }

    public User getUserRecipient() {
        return userRecipient;
    }

    public void setUserRecipient(User userRecipient) {
        this.userRecipient = userRecipient;
    }
}
