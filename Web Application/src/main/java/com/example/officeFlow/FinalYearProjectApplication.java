package com.example.officeFlow;

import com.example.officeFlow.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.example.officeFlow.model.*;

import java.sql.Date;
import java.time.LocalDate;

@SpringBootApplication
public class FinalYearProjectApplication implements CommandLineRunner {

	@Autowired
	private SensorTypeService sensorTypeService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private UserService userService;
    @Autowired
    private HubService hubService;

	@Autowired
	private SensorService sensorService;

	@Autowired
	private ActuatorTypeService actuatorTypeService;

	@Autowired
	private ActuatorService actuatorService;

	@Autowired
	private NotificationTypeService notificationTypeService;

	@Autowired
	private SensorReadingService sensorReadingService;



	public static void main(String[] args) {
		SpringApplication.run(FinalYearProjectApplication.class, args);
	}

	@Override
	public void run(String... arg) {
		//*******************************************************************************************************
		//START OF RUN ONCE SECTION - COMMENT OUT ONCE RAN ONCE

//		Inserts static sensor type records
//		SensorType sensorType1 = new SensorType();
//		sensorType1.setName("Light");
//		sensorType1.setDescription("Checks the ambient light in the room");
//		sensorType1.setUnit("Lux");
//		sensorType1.setDefaultThreshold(500);
//		sensorTypeService.save(sensorType1);
//
//		ActuatorType actuatorType1 = new ActuatorType();
//		actuatorType1.setName("Lamp");
//		actuatorType1.setDescription("Turns the light on and off");
//		actuatorType1.setPartnerSensorType(sensorType1);
//		actuatorTypeService.save(actuatorType1);
//		sensorType1.setPartnerActuatorType(actuatorType1);
//		sensorTypeService.save(sensorType1);
//
//		SensorType sensorType2 = new SensorType();
//		sensorType2.setName("Temperature");
//		sensorType2.setDescription("Measures the temperature of the room");
//		sensorType2.setUnit("Celsius");
//		sensorType2.setDefaultThreshold(18);
//		sensorTypeService.save(sensorType2);
//
//		ActuatorType actuatorType2 = new ActuatorType();
//		actuatorType2.setName("Fan");
//		actuatorType2.setDescription("Turns the fan on and off");
//		actuatorType2.setPartnerSensorType(sensorType2);
//		actuatorTypeService.save(actuatorType2);
//		sensorType2.setPartnerActuatorType(actuatorType2);
//		sensorTypeService.save(sensorType2);
//
//		SensorType sensorType3 = new SensorType();
//		sensorType3.setName("Occupancy");
//		sensorType3.setDescription("Checks if the user is present");
//		sensorType3.setUnit("Centimeters");
//		sensorType3.setDefaultThreshold(60); //60cm
//
//		SensorType sensorType4 = new SensorType();
//		sensorType4.setName("Heart");
//		sensorType4.setDescription("Checks the heart rate of the user");
//		sensorType4.setUnit("BPM");
//		sensorType4.setDefaultThreshold(70);
//
//		sensorTypeService.save(sensorType1);
//		sensorTypeService.save(sensorType2);
//		sensorTypeService.save(sensorType3);
//		sensorTypeService.save(sensorType4);
//		actuatorTypeService.save(actuatorType1);
//		actuatorTypeService.save(actuatorType2);
//
//
//		//Inserts static device records for mac addresses and pair codes
//
//		//Hub
//		Hub hub1 = new Hub();
//		hub1.setActive(false);
//		hub1.setHubMacAddress("FC:B4:67:74:22:54");
//		hub1.setPairingCode("5BTIZ6");
//		hubService.save(hub1);
//
//		//Occupancy
//		Sensor sensor1 = new Sensor();
//		sensor1.setActive(false);
//		sensor1.setMacAddress("E4:65:B8:79:1C:3C");
//		sensor1.setPairingCode("1BETX5");
//		sensor1.setSensorType(sensorType3);
//		sensor1.setThreshold(60);
//		sensorService.save(sensor1);
//
//		//Light
//		Sensor sensor2 = new Sensor();
//		sensor2.setActive(false);
//		sensor2.setMacAddress("a0:b7:65:22:f5:fc");
//		sensor2.setPairingCode("SE9WP8");
//		sensor2.setSensorType(sensorType1);
//		sensor2.setThreshold(500);
//		sensorService.save(sensor2);
//
//		//Lamp
//		Actuator actuator1 = new Actuator();
//		actuator1.setActive(false);
//		actuator1.setMacAddress("f8:b3:b7:2a:bf:9c");
//		actuator1.setPairingCode("I9RXFJ");
//		actuator1.setActuatorType(actuatorType1);
//		actuatorService.save(actuator1);
//
//		//Temperature
//		Sensor sensor3 = new Sensor();
//		sensor3.setActive(false);
//		sensor3.setMacAddress("1c:69:20:e9:18:8c");
//		sensor3.setPairingCode("28VDTA");
//		sensor3.setSensorType(sensorType2);
//		sensor3.setThreshold(18);
//		sensorService.save(sensor3);
//
//		//Fan
//		Actuator actuator2 = new Actuator();
//		actuator2.setActive(false);
//		actuator2.setMacAddress("a0:b7:65:21:e4:94");
//		actuator2.setPairingCode("K2XZFD");
//		actuator2.setActuatorType(actuatorType2);
//		actuatorService.save(actuator2);
//
//		//Heart
//		Sensor sensor4 = new Sensor();
//		sensor4.setActive(false);
//		sensor4.setMacAddress("a0:b7:65:24:31:40");
//		sensor4.setPairingCode("IS2D2R");
//		sensor4.setSensorType(sensorType4);
//		sensor4.setThreshold(70);
//		sensorService.save(sensor4);
//
//
//		//Static Notification types
//		NotificationType notificationType1 = new NotificationType();
//		notificationType1.setNotificationTypeId(1);
//		notificationType1.setMessage("The light levels are too low");
//		notificationTypeService.save(notificationType1);
//
//		NotificationType notificationType2 = new NotificationType();
//		notificationType2.setNotificationTypeId(2);
//		notificationType2.setMessage("The light levels are too lowe, turning on lamp");
//		notificationTypeService.save(notificationType2);
//
//		NotificationType notificationType3 = new NotificationType();
//		notificationType3.setNotificationTypeId(3);
//		notificationType3.setMessage("You have been sitting down for over 30 minutes. Please stand up and and move about");
//		notificationTypeService.save(notificationType3);
//
//		NotificationType notificationType4 = new NotificationType();
//		notificationType4.setNotificationTypeId(4);
//		notificationType4.setMessage("The room is a bit hot");
//		notificationTypeService.save(notificationType4);
//
//		NotificationType notificationType5 = new NotificationType();
//		notificationType5.setNotificationTypeId(5);
//		notificationType5.setMessage("The room is a bit hot, turning on the fan");
//		notificationTypeService.save(notificationType5);
//
//		NotificationType notificationType6 = new NotificationType();
//		notificationType6.setNotificationTypeId(6);
//		notificationType6.setMessage("Your heart rate is more elevated than normal - perhaps it is time to take a break?");
//		notificationTypeService.save(notificationType6);
//
//		//Hardcoded hub credentials
//		User user2 = new User();
//		user2.setEmail("hubAccount");
//		user2.setName("hubAccount");
//		user2.setPassword(passwordEncoder.encode("8dOB3evsKDUxBIcEel5eQ8Qli4hSlj07"));
//		user2.setDateOfBirth(Date.valueOf("1970-01-01"));
//		userService.save(user2);
//
//		//Hardcoded admin credentials
//		User admin = new User();
//		admin.setEmail("admin@admin");
//		admin.setName("Admin");
//		admin.setPassword(passwordEncoder.encode("MV4YPLULtmBRVKWKNWTvxgX1PxQYTkrS"));
//		admin.setDateOfBirth(Date.valueOf("1970-01-01"));
//		userService.save(admin);
//
////		***************************************************************************************************************************************************************
////		END OF RUN ONCE SECTION

		//For mock data, just import the database file

	}


}
