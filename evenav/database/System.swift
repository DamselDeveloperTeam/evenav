//
//  System.swift
//  EveDatabase
//
//  Created by Janne Kemppi on 8.11.2017.
//  Copyright © 2017 ?. All rights reserved.
//

import Foundation

class System {
    let id: Int;
    let name: String;
    let constellationID: Int;
    let securityStatus: Double;
    let pX: Int;
    let pY: Int;
    let pZ: Int;
    
    init(id: Int, name: String, constellationID: Int,securityStatus: Double, pX: Int, pY: Int, pZ: Int) {
        self.id = id;
        self.name = name;
        self.constellationID = constellationID;
        self.securityStatus = securityStatus;
        self.pX = pX;
        self.pY = pY;
        self.pZ = pZ;
    }
}

