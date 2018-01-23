//
//  RouteFinder.swift
//  evenav
//
//  Created by Janne Kemppi on 5.1.2018.
//  Copyright © 2018 Koulutus. All rights reserved.
//

import Foundation


class RouteFinder {
    var routeNodes: [Int] = [];
    
    func findRouteFor(origin: Int, destination: Int) -> Bool {
        let routeReguestURL = URL(string: "https://esi.tech.ccp.is/latest/route/" + String(origin) + "/" + String(destination) + "/?datasource=tranquility&flag=shortest")!;
        
        do {
            self.routeNodes = [];
            clearRouteHighlight(); //clears previously highlighted route
            try getRoute(url: routeReguestURL);
            highlightRouteOnMap(routeNodes: self.routeNodes);
        } catch let error {
            handleError(error: error);
            return false
        }
        
        return true
    }
    
    private func getRoute (url: URL) throws {
        let request = JsonHttpRequest(address: url);
        let jsonData = try request.perform();
        
        guard let routeNodes = jsonData as? [Int] else {
            throw RouteFinderError.jsonParsingFailed;
        }
        
        NSLog("Route: \(routeNodes)");
        self.routeNodes = routeNodes;
    }
    
    private func handleError(error: Error) {
        switch error {
        case JsonHttpRequest.HttpError.error404(let errorMsg):
            NSLog("httpError: " + errorMsg);
        case JsonHttpRequest.HttpError.internalServerError(let errorMsg):
            NSLog("httpError: " + errorMsg);
        case JsonHttpRequest.HttpError.otherHttpError(let statusCode):
            NSLog("httpError: statuscode(\(statusCode))");
        case RouteFinderError.jsonParsingFailed:
            NSLog("jsonParsingFailedError");
        default:
            NSLog(error.localizedDescription);
            AlertDisplayer.noInternetConnectionRouteAlert();
        }
    }
    
    private func highlightRouteOnMap(routeNodes: [Int]) {
        var highlightCount: Int = 0;
        
        for i in 0..<routeNodes.count-1 {
            if ( hightlightRoute(sys1_ID: routeNodes[i], sys2_ID: routeNodes[i+1]) ) {
                highlightCount += 1;
            }
            
            if (highlightCount >= routeNodes.count) {
                break; //All required connectors highlighted, skipping rest
            }
        }
    }
    
    private func hightlightRoute(sys1_ID: Int, sys2_ID: Int) -> Bool {
        for sysCon in Connectors {
            if sysCon.connection_id[0] == sys1_ID && sysCon.connection_id[1] == sys2_ID {
                //sysCon.gateType = 3; //Change connector color to yellow
                sysCon.isHighlighted = true; //Highlight connector
                NSLog("Changed connector \(sysCon.connection_id) to yellow!");
                return true;
            }
            if sysCon.connection_id[0] == sys2_ID && sysCon.connection_id[1] == sys1_ID {
                //sysCon.gateType = 3; //Change connector color to yellow
                sysCon.isHighlighted = true; //Highlight connector
                NSLog("Changed connector \(sysCon.connection_id) to yellow!");
                return true;
            }
        }
        return false;
    }
    
    private func clearRouteHighlight() {
        for sysCon in Connectors {
            sysCon.isHighlighted = false;
        }
    }
    
    public func changeRouteColor() {
        //var sys1_ID: Int = 0;
        //var sys2_ID: Int = 0;
    
        //findRouteFor(origin: 30002771, destination: 30002772);
        
        /*
        for sysButton in Systems {
            if sysButton.name == "Maurasi" {
                sys1_ID = sysButton.id;
                NSLog("Maurasi's id: \(sys1_ID)");
            }
            if sysButton.name == "Itamo" {
                sys2_ID = sysButton.id;
                NSLog("Itamo's id: \(sys2_ID)");
            }
        }
    
        for sysCon in Connectors {
            if sysCon.connection_id[0] == sys1_ID && sysCon.connection_id[1] == sys2_ID {
                sysCon.gateType = 3; //Change connector color to yellow
                NSLog("Changed connector \(sysCon.connection_id) to yellow!");
            }
            if sysCon.connection_id[0] == sys2_ID && sysCon.connection_id[1] == sys1_ID {
                sysCon.gateType = 3; //Change connector color to yellow
                NSLog("Changed connector \(sysCon.connection_id) to yellow!");
            }
        }
        */
    }
    
    enum RouteFinderError: Error {
        case jsonParsingFailed;
    }

}
