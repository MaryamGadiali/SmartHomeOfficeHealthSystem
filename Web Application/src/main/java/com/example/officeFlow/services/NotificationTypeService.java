package com.example.officeFlow.services;

import com.example.officeFlow.model.NotificationType;
import com.example.officeFlow.repositories.NotificationTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class NotificationTypeService {

    @Autowired
    private NotificationTypeRepository notificationTypeRepository;

    public Optional<NotificationType> findNotificationTypeById(int id) {
        return notificationTypeRepository.findById(id);
    }

    public void save(NotificationType notificationType) {
        notificationTypeRepository.save(notificationType);
    }

    public Optional<NotificationType> findNotificationTypeForSensorType(String sensorTypeName, boolean isAutomated) {

        if (sensorTypeName.equals("Light") && !isAutomated){
            return notificationTypeRepository.findById(1);
        }
        else if (sensorTypeName.equals("Light") && isAutomated) {
            return notificationTypeRepository.findById(2);
        } //leave 3 out
        else if(sensorTypeName.equals("Temperature") && !isAutomated) {
            return notificationTypeRepository.findById(4);
        }
        else if(sensorTypeName.equals("Temperature") && isAutomated){
            return notificationTypeRepository.findById(5);
        }
        else if(sensorTypeName.equals("Heart")){
            return notificationTypeRepository.findById(6);
        }
        return Optional.empty();
    }
}
