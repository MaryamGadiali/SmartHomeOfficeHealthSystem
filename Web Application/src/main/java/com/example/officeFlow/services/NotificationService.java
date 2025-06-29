package com.example.officeFlow.services;

import com.example.officeFlow.model.Notification;
import com.example.officeFlow.model.NotificationType;
import com.example.officeFlow.model.User;
import com.example.officeFlow.repositories.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Optional;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public String findEarliestUnreadNotification(User user) {
        Notification notification = notificationRepository.findFirstByUserRecipientAndHasBeenDisplayedAndTimestampAfter(user, false, LocalDateTime.now().minusMinutes(5));
        if (notification == null) {
            return "null";
        }
        notification.setHasBeenDisplayed(true);
        notificationRepository.save(notification);
        return notification.getNotificationType().getMessage();
    }

    public void save(Notification notification) {
        notificationRepository.save(notification);
    }

    public void deleteUserNotifications(User user) {
        notificationRepository.deleteAllByUserRecipient(user);
    }

    public long findTimeOfLatestNotificationSentOfType(User user, NotificationType notificationType) { //need to check this
        Notification notification = notificationRepository.findFirstByUserRecipientAndNotificationTypeOrderByTimestampDesc(user, notificationType);
        return notification.getTimestamp().toEpochSecond(ZoneOffset.ofHours(1));
    }
}
