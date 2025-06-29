package com.example.officeFlow.repositories;

import com.example.officeFlow.model.Hub;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HubRepository extends CrudRepository<Hub, Integer> {
    Hub findByPairingCode(String pairingCode);

    Hub findByHubMacAddress(String hubMacAddress);
}
