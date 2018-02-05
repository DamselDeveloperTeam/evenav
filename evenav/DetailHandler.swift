//
//  DetailHandler.swift
//  evenav
//
//  Copyright © 2018 Koulutus. All rights reserved.
//

import Foundation

class DetailHander {
    
    func getDetailsForSystem (systemID: Int) -> String? {
        var detailInformation: String = "";
        
        guard let foundSystem = findSystemById(systemIdToSearch: systemID) else {
            NSLog("No system by id: \(systemID) found from array!");
            return nil
        }
        
        detailInformation = detailInformation + "Name:\n" + foundSystem.name + "\n\nSecurity status:\n" + String(format:"%.2f", foundSystem.securityStatus);
        
        //String(format:"%.2f", foundSystem.securityStatus)
        
        guard let foundConstellation = findConstellationById(constellationIdToSearch: foundSystem.constellation) else {
            NSLog("No constellation by id: \(foundSystem.constellation) found from array!");
            return nil
        }
        
        detailInformation = detailInformation + "\n\nConstellation:\n" + foundConstellation.name;
        
        guard let foundRegion = findRegionById(regionIdToSearch: foundSystem.region) else {
            NSLog("No region by id: \(foundSystem.region) found from array!");
            return nil
        }
        
        detailInformation = detailInformation + "\n\nRegion:\n" + foundRegion.name;
        
        /*
        var connectedSystemNames: [String] = [];
        for connectedSystemID in foundSystem.connectsToSystem {
            guard let foundSystem = findSystemById(systemIdToSearch: connectedSystemID) else {
                NSLog("No system by id: \(connectedSystemID) found from array!");
                return nil
            }
            connectedSystemNames.append(foundSystem.name);
        }
         */
        
        //var connectedSystems: [System] = [];
        guard let connectedSystems = DataBase.sharedInstance.getConnectionsTo(system: System(id: foundSystem.id, name: "", constellationID: 0, securityStatus: 0, pX: 0, pY: 0, pZ: 0)) else {
            NSLog("No connections found for system by id: \(foundSystem.id)");
            return nil
        }
        
        detailInformation = detailInformation + "\n\nAdjacent systems:\n";
        
        for connectedSystem in connectedSystems {
            detailInformation = detailInformation + connectedSystem.name + "\n";
        }
        
        /*
        for connectedSystemName in connectedSystemNames {
            detailInformation = detailInformation + "\n" + connectedSystemName;
        }
         */
        
        return detailInformation;
    }
}
