//
//  EveSystemConnectionFinder.swift
//  eve
//
//  Created by Koulutus on 17.11.2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

class ConnectionFinder {
    var connections: [Int] = [];
    var starGates: [Int] = [];
    
    func findConnectionsFor(systemID: Int) -> [Int]? {
        connections = [];
        starGates = [];
        let systemURL = URL(string: "https://esi.tech.ccp.is/latest/universe/systems/" + String(systemID) + "/?datasource=tranquility&language=en-us")!;
        
        do {
            try getStarGates(url: systemURL);
            try getConnectedSystems();
            //try performTestPrint(systemID: systemID);
        } catch let error {
            handleError(error: error);
            return nil
        }
        
        return connections
    }
    
    private func handleError(error: Error) {
        switch error {
        case JsonHttpRequest.HttpError.error404(let errorMsg):
            NSLog("httpError: " + errorMsg);
        case JsonHttpRequest.HttpError.internalServerError(let errorMsg):
            NSLog("httpError: " + errorMsg);
        case JsonHttpRequest.HttpError.otherHttpError(let statusCode):
            NSLog("httpError: statuscode(\(statusCode))");
        case ConnectionFinderError.jsonParsingFailed:
            NSLog("jsonParsingFailedError");
        default:
            NSLog(error.localizedDescription);
        }
    }
    
    private func performTestPrint(systemID: Int) throws {
        var msg: String = "\(systemID) \(try getSystemName(id: systemID)) connected to:\n";
        for sys in connections {
            msg += "\(sys) \(try getSystemName(id: sys)), ";
        }
            NSLog(msg)
    }
    
    private func getSystemName(id: Int) throws -> String {
        let systemURL = URL(string: "https://esi.tech.ccp.is/latest/universe/systems/" + String(id) + "/?datasource=tranquility&language=en-us")!;
        
        let request = JsonHttpRequest(address: systemURL);
        let jsonData = try request.perform();
        
        guard let system = jsonData as? [String:Any], let systemName = system["name"] as? String else {
            throw ConnectionFinderError.jsonParsingFailed;
        }
        
        return systemName
    }
    
    private func getStarGates (url: URL) throws {
        let request = JsonHttpRequest(address: url);
        let jsonData = try request.perform();
        
        guard let system = jsonData as? [String:Any], let sgates = system["stargates"] as? [Int] else {
            throw ConnectionFinderError.jsonParsingFailed;
        }
        self.starGates = sgates;
    }
    
    private func getConnectedSystems () throws {
        var request: JsonHttpRequest;
        var jsonData: Any;
        
        for sgate in starGates {
            let starGateURL = URL(string: "https://esi.tech.ccp.is/latest/universe/stargates/" + String(sgate) + "/?datasource=tranquility&language=en-us")!;
            request = JsonHttpRequest(address: starGateURL);
            jsonData = try request.perform();
            
            guard let system = jsonData as? [String:Any],
            let destination = system["destination"] as? [String:Any],
            let systemID = destination["system_id"] as? Int else {
                throw ConnectionFinderError.jsonParsingFailed;
            }
            self.connections.append(systemID);
        }
    }
    
    enum ConnectionFinderError: Error {
        case jsonParsingFailed;
    }
    
}
