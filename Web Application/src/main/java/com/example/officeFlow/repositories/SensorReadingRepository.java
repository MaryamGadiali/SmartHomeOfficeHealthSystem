package com.example.officeFlow.repositories;

import com.example.officeFlow.model.SensorReading;
import com.example.officeFlow.model.SensorType;
import com.example.officeFlow.model.User;
import jakarta.transaction.Transactional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SensorReadingRepository extends CrudRepository<SensorReading, Integer> {
    List<SensorReading> findAllByUserAndTypeAndTimestampBetween(User user, SensorType type, LocalDateTime timestampAfter, LocalDateTime timestampBefore);

    List<SensorReading> findAllByUserAndTypeAndValue(User user, SensorType type, float value);

    List<SensorReading> findFirstByUserAndTypeOrderByTimestampAsc(User user, SensorType type);

    boolean existsByUser(User user);

    boolean existsByUserAndTimestampBefore(User user, LocalDateTime timestampBefore);

    @Transactional
    void deleteAllByUser(User user);

}
