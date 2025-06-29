package com.example.officeFlow.services;

import com.example.officeFlow.model.*;
import com.example.officeFlow.repositories.SensorReadingRepository;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class SensorReadingService {

    @Autowired
    private SensorReadingRepository sensorReadingRepository;

    @Autowired
    private SensorTypeService sensorTypeService;

    public void saveSensorReading(SensorReading sensorReading) {
        sensorReadingRepository.save(sensorReading);
    }

    public List<SensorReading> getAllReadingsOfTypeForUserForToday(Hub hub, String name) {
        //If type == occupancy, then also need to check for a current running session
        SensorType sensorType = sensorTypeService.findSensorTypeByName(name);
        if (name.equals("Occupancy")) {
            SensorReading sr = findMatchingOccupancyStartReading(hub);
            //Makes changes just for the dashboard without making changes to the database
            if (sr != null) {
                float cumulativePresentTime = Float.parseFloat(String.format("%.2f", (LocalDateTime.now().toEpochSecond(ZoneOffset.ofHours(1)) - sr.getTimestamp().toEpochSecond(ZoneOffset.ofHours(1))) / 60.0));
                sr.setValue(cumulativePresentTime - 1); //To counteract the 1 that was added
                List<SensorReading> sensorReadings = sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(hub.getHubOwner(), sensorType, LocalDate.now().atStartOfDay(), LocalDate.now().atStartOfDay().plusDays(1));
                sensorReadings.add(sr);
                return sensorReadings;
            }
        }
        return sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(hub.getHubOwner(), sensorType, LocalDate.now().atStartOfDay(), LocalDate.now().atStartOfDay().plusDays(1));
    }

    public SensorReading findMatchingOccupancyStartReading(Hub hub) {
        SensorType sensorType = sensorTypeService.findSensorTypeByName("Occupancy");
        List<SensorReading> sensorReadingMatches = sensorReadingRepository.findAllByUserAndTypeAndValue(hub.getHubOwner(), sensorType, 1);
        if (!sensorReadingMatches.isEmpty()) {
            return sensorReadingMatches.get(sensorReadingMatches.size() - 1); //Only get the latest match if more than 1
        }
        return null;
    }

    //Light and Heart for week,month,all
    public String getHistReadingsPerHourForNumDays(User user, String option, String type) {
        System.out.println("Option is: ");
        System.out.println(option);
        LocalDateTime startDate;
        if (option.equals("Week")) {
            startDate = LocalDate.now().minusDays(7).atStartOfDay();
        } else if (option.equals("Month")) {
            startDate = LocalDate.now().minusDays(30).atStartOfDay();
        } else if (option.equals("All")) {
            List<SensorReading> sensorReadings = (sensorReadingRepository.findFirstByUserAndTypeOrderByTimestampAsc(user, sensorTypeService.findSensorTypeByName(type)));
            if (sensorReadings.size() > 0) {
                startDate = sensorReadings.get(0).getTimestamp();
            } else {
                return "{}";
            }
        } else {
            startDate = LocalDate.now().atStartOfDay();
        }
        SensorType sensorType = sensorTypeService.findSensorTypeByName(type);
        JSONObject hourAndRecords = new JSONObject();
        //Group the relevant records by hour
        for (SensorReading record : sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(user, sensorType, startDate, LocalDate.now().atStartOfDay())) {
            if (!hourAndRecords.toMap().containsKey(String.valueOf(record.getTimestamp().getHour()))) {
                JSONArray records = new JSONArray();
                records.put(record.getValue());
                hourAndRecords.put(String.valueOf(record.getTimestamp().getHour()), records);
            } else { //If the key already exists
                hourAndRecords.getJSONArray(String.valueOf(record.getTimestamp().getHour())).put(record.getValue());
            }
        }
        return hourAndRecords.toString();
    }

    //Light and Heart for custom
    public String getHistReadingsPerHourForCustomRange(User user, String option, String type, String startDate, String endDate) {
        LocalDateTime startDateTime = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyy-MM-dd")).atStartOfDay();
        LocalDateTime endDateTime = LocalDate.parse(endDate, DateTimeFormatter.ofPattern("yyyy-MM-dd")).atStartOfDay().plusHours(23).plusMinutes(59).plusSeconds(59);
        SensorType sensorType = sensorTypeService.findSensorTypeByName(type);
        JSONObject hourAndRecords = new JSONObject();

        for (SensorReading record : sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(user, sensorType, startDateTime, endDateTime)) {
            if (!hourAndRecords.toMap().containsKey(String.valueOf(record.getTimestamp().getHour()))) {
                JSONArray records = new JSONArray();
                records.put(record.getValue());
                hourAndRecords.put(String.valueOf(record.getTimestamp().getHour()), records);
            } else { //If the key already exists
                hourAndRecords.getJSONArray(String.valueOf(record.getTimestamp().getHour())).put(record.getValue());
            }
        }
        return hourAndRecords.toString();
    }

    //Temperature and Occupancy for week, month, all
    public String getHistReadingsPerDayForNumDays(User user, String option, String type) {
        System.out.println("Option is: ");
        System.out.println(option);
        LocalDateTime startDate;
        if (option.equals("Week")) {
            startDate = LocalDate.now().minusDays(7).atStartOfDay();
        } else if (option.equals("Month")) {
            startDate = LocalDate.now().minusDays(30).atStartOfDay();
        } else if (option.equals("All")) {
            List<SensorReading> sensorReadings = (sensorReadingRepository.findFirstByUserAndTypeOrderByTimestampAsc(user, sensorTypeService.findSensorTypeByName(type)));
            if (sensorReadings.size() > 0) {
                startDate = sensorReadings.get(0).getTimestamp();
            } else {
                return "{}";
            }
        } else {
            startDate = LocalDate.now().atStartOfDay();
        }
        SensorType sensorType = sensorTypeService.findSensorTypeByName(type);
        JSONObject valuesPerDay = new JSONObject();
        //Groups the records by day
        for (SensorReading record : sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(user, sensorType, startDate, LocalDate.now().minusDays(1).atTime(LocalTime.parse("23:59:59")))) {
            if (!valuesPerDay.toMap().containsKey(String.valueOf(record.getTimestamp().toLocalDate()))) {
                JSONArray records = new JSONArray();
                records.put(record.getValue());
                valuesPerDay.put(String.valueOf(record.getTimestamp().toLocalDate()), records);
            } else {
                valuesPerDay.getJSONArray(String.valueOf(record.getTimestamp().toLocalDate())).put(record.getValue());
            }
        }
        return valuesPerDay.toString();
    }

    //Temperature and Occupancy for custom
    public String getHistReadingsPerDayForCustomRange(User user, String option, String type, String startDate, String endDate) {
        LocalDateTime startDateTime = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyy-MM-dd")).atStartOfDay();
        LocalDateTime endDateTime = LocalDate.parse(endDate, DateTimeFormatter.ofPattern("yyyy-MM-dd")).atStartOfDay().plusHours(23).plusMinutes(59).plusSeconds(59);
        SensorType sensorType = sensorTypeService.findSensorTypeByName(type);
        JSONObject averagePerDay = new JSONObject();

        for (SensorReading record : sensorReadingRepository.findAllByUserAndTypeAndTimestampBetween(user, sensorType, startDateTime, endDateTime)) {
            if (!averagePerDay.toMap().containsKey(String.valueOf(record.getTimestamp().toLocalDate()))) {
                JSONArray records = new JSONArray();
                records.put(record.getValue());
                averagePerDay.put(String.valueOf(record.getTimestamp().toLocalDate()), records);
            } else { //If the key already exists
                averagePerDay.getJSONArray(String.valueOf(record.getTimestamp().toLocalDate())).put(record.getValue());
            }
        }
        return averagePerDay.toString();
    }

    public boolean hasReadingsForUser(User user) {
        return sensorReadingRepository.existsByUser(user);
    }

    public boolean hasPastDataForUser(User user) {
        return sensorReadingRepository.existsByUserAndTimestampBefore(user, LocalDateTime.now().minusDays(1).withHour(23).withMinute(59).withSecond(59));
    }

    public void deleteUserReadings(User user) {
        sensorReadingRepository.deleteAllByUser(user);
    }

    public void deleteSensorReading(SensorReading startSensorReading) { //Future implementation
        sensorReadingRepository.delete(startSensorReading);
    }

    public void saveSensorReadings(SensorReading[] sensorReadings) { //Future implementation
        sensorReadingRepository.saveAll(Arrays.asList(sensorReadings));
    }
}
