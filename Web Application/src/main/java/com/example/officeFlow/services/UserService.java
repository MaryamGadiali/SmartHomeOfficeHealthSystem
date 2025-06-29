package com.example.officeFlow.services;

import com.example.officeFlow.model.Hub;
import com.example.officeFlow.model.Sensor;
import com.example.officeFlow.model.User;
import com.example.officeFlow.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Map;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SensorReadingService sensorReadingService;

    @Autowired
    private SensorService sensorService;

    @Autowired
    private NotificationService notificationService;

    public void save(User user) {
        userRepository.save(user);
    }


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username);
        if (user == null) {
            throw new UsernameNotFoundException("User not found with email: " + username);
        }
        if (user.getEmail().equals("hubAccount")) {
            return org.springframework.security.core.userdetails.User.builder()
                    .username(user.getEmail())
                    .password(user.getPassword())
                    .roles("HUB")
                    .build();
        }
        if (user.getEmail().equals("admin@admin")) {
            return org.springframework.security.core.userdetails.User.builder()
                    .username(user.getEmail())
                    .password(user.getPassword())
                    .roles("ADMIN")
                    .build();
        }
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles("USER")
                .build();
    }

    public User findLoggedInUser() {
        String username = ((UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getUsername();
        return userRepository.findByEmail(username);
    }

    public void matchUserToHub(User u, Hub hub) {
        u.setHub(hub);
        userRepository.save(u);
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public void deleteAccount() {
        User user = findLoggedInUser();
        sensorReadingService.deleteUserReadings(user);

        Map<String, Sensor> sensors = user.getOwnedSensors();
        for (Sensor sensor : new ArrayList<>(sensors.values())) {
            if (sensor.getPartnerActuator() == null && !sensor.getSensorType().getName().equals("Occupancy")) {
                sensorService.deleteDeviceFromNetwork(sensor.getSensorId());
            } else if (sensor.getPartnerActuator() != null && !sensor.getSensorType().getName().equals("Occupancy")) {
                sensorService.deleteDevicesFromNetwork(sensor.getSensorId());
            }
        }
        if (user.getHub() != null) {
            sensorService.deleteCoreDevicesFromNetwork(user.getHub().getHubMacAddress());
        }
        notificationService.deleteUserNotifications(user);
        userRepository.delete(user);
    }

    public String getCurrentUserName() {
        Object userDetails = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (userDetails instanceof UserDetails) {
            if (userRepository.findByEmail(((UserDetails) userDetails).getUsername()) != null) {
                String name = userRepository.findByEmail(((UserDetails) userDetails).getUsername()).getName();
                if (name != null) {
                    return name.substring(0, 1).toUpperCase() + name.substring(1);
                }
            }

        }
        return null;
    }

}
