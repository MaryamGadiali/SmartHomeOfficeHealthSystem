package com.example.officeFlow.services;

import com.example.officeFlow.model.Actuator;
import com.example.officeFlow.model.Hub;
import com.example.officeFlow.model.User;
import com.example.officeFlow.repositories.HubRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Map;

@Service
public class HubService {

    @Autowired
    private HubRepository hubRepository;

    public Hub checkHubPairingCode(String hubCode) {
        return hubRepository.findByPairingCode(hubCode);
    }

    public void save(Hub hub) {
        hubRepository.save(hub);
    }

    public void matchHubToUser(Hub hub, User user) {
        hub.setActive(true);
        hub.setHubOwner(user);
        hub.setImplementationTimestamp(LocalDateTime.now());
        hub.setRemovalTimestamp(null);
        hubRepository.save(hub);
    }

    public Hub findHubByMacAddress(String hubMacAddress) {
        return hubRepository.findByHubMacAddress(hubMacAddress);
    }

    public String retrievePendingCommands(Hub hub) {
        String commands = hub.getPendingCommandsString();
        hub.emptyPendingCommands();
        save(hub);
        return commands;
    }

    public void updateLastTimeRecordedOfUser(Hub hub, LocalDateTime dateTime) {
        hub.setLastSeatingUpdate(dateTime.toEpochSecond(ZoneOffset.ofHours(1)));
        hubRepository.save(hub);
    }


    public String getPairingCode(String macAddress) {
        return hubRepository.findByHubMacAddress(macAddress).getPairingCode();
    }
}
