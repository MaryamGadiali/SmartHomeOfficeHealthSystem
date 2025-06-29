package com.example.officeFlow.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

@Entity
@Table(name = "hub")
public class Hub {

    @Id
    @Column(name = "hubMacAddress")
    private String hubMacAddress;

    @Column(name = "pairingCode")
    private String pairingCode;

    @Column(name = "implementationTimestamp")
    private LocalDateTime implementationTimestamp;

    @Column(name = "removalTimestamp")
    private LocalDateTime removalTimestamp;

    @Column(name = "isActive")
    private boolean isActive;

    @Column(name = "pairCodeUsed")
    private boolean pairCodeUsed;

    @Column(name = "pendingCommands", columnDefinition = "MEDIUMTEXT")
    public String pendingCommands;

    @Column(name="seatingStartTime")
    private long seatingStartTime =0;

    @Column(name="lastSeatingUpdate")
    private long lastSeatingUpdate =0;

    @OneToOne
    @JoinColumn
    private User hubOwner;

    public boolean isPairCodeUsed() {
        return pairCodeUsed;
    }

    public void setPairCodeUsed(boolean pairCodeUsed) {
        this.pairCodeUsed = pairCodeUsed;
    }

    public User getHubOwner() {
        return hubOwner;
    }

    public void setHubOwner(User hubOwner) {
        this.hubOwner = hubOwner;
    }

    public String getPairingCode() {
        return pairingCode;
    }

    public void setPairingCode(String pairingCode) {
        this.pairingCode = pairingCode;
    }

    public LocalDateTime getImplementationTimestamp() {
        return implementationTimestamp;
    }

    public void setImplementationTimestamp(LocalDateTime implementationTimestamp) {
        this.implementationTimestamp = implementationTimestamp;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getHubMacAddress() {
        return hubMacAddress;
    }

    public void setHubMacAddress(String hubMacAddress) {
        this.hubMacAddress = hubMacAddress;
    }

    public String getPendingCommandsString() {
        String commands=pendingCommands;
        return commands;
    }

    public void addPendingCommand(int command, Object message) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("command",command);
        jsonObject.put("message", message);
        if (this.pendingCommands == null) {
            JSONArray jsonArray = new JSONArray();
            jsonArray.put(jsonObject);
            this.pendingCommands = jsonArray.toString();
        } else {
            JSONArray jsonPendingCommands = new JSONArray(pendingCommands);
            jsonPendingCommands.put(jsonObject);
            this.pendingCommands = jsonPendingCommands.toString();
        }
    }

    public void emptyPendingCommands() {
        this.pendingCommands = null;
    }

    public long getSeatingStartTime() {
        return seatingStartTime;
    }

    public void setSeatingStartTime(long seatingStartTime) {
        this.seatingStartTime = seatingStartTime;
    }

    public long getLastSeatingUpdate() {
        return lastSeatingUpdate;
    }

    public void setLastSeatingUpdate(long lastSeatingUpdate) {
        this.lastSeatingUpdate = lastSeatingUpdate;
    }

    public String getPendingCommands() {
        return pendingCommands;
    }

    public void setPendingCommands(String pendingCommands) {
        this.pendingCommands = pendingCommands;
    }

    public LocalDateTime getRemovalTimestamp() {
        return removalTimestamp;
    }

    public void setRemovalTimestamp(LocalDateTime removalTimestamp) {
        this.removalTimestamp = removalTimestamp;
    }
}

