package com.example.officeFlow.repositories;

import com.example.officeFlow.model.Notification;
import com.example.officeFlow.model.NotificationType;
import com.example.officeFlow.model.User;
import jakarta.transaction.Transactional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface NotificationRepository extends CrudRepository<Notification, Integer> {

    @Transactional
    void deleteAllByUserRecipient(User userRecipient);

    Notification findFirstByUserRecipientAndNotificationTypeOrderByTimestampDesc(User userRecipient, NotificationType notificationType);

    Notification findFirstByUserRecipientAndHasBeenDisplayedAndTimestampAfter(User userRecipient, boolean hasBeenDisplayed, LocalDateTime timestampAfter);
}
