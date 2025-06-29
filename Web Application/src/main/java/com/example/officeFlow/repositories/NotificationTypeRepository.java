package com.example.officeFlow.repositories;

import com.example.officeFlow.model.NotificationType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationTypeRepository extends CrudRepository<NotificationType,Integer> {
}
