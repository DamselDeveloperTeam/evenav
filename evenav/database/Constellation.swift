//
//  Constellation.swift
//  EveDatabase
//
//  Created by Janne Kemppi on 6.12.2017.
//  Copyright © 2017 ?. All rights reserved.
//

import Foundation

class Constellation {
    let id: Int;
    let name: String;
    let region: Int;
    let pX: Int;
    let pY: Int;
    let pZ: Int;
    
    init(id: Int, name: String, region: Int, pX: Int, pY: Int, pZ: Int) {
        self.id = id;
        self.name = name;
        self.region = region;
        self.pX = pX;
        self.pY = pY;
        self.pZ = pZ;
    }
}
