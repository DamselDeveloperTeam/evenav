//
//  Constellation.swift
//  eve
//
//  Created by Koulutus on 08/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

class ConstellationJSON : Codable
{
    var constellation_id : Int
    var name : String
    var position : Position
    var region_id : Int
    var systems : [Int]
    
    /*
    init(constellation_id : Int, name : String, position : Position, region_id : Int, systems : Systems) {
        self.constellation_id = constellation_id
        self.name = name
        self.position = position
        self.region_id = region_id
        self.systems = systems
    }
    */
}
