//
//  Region.swift
//  eve
//
//  Created by Koulutus on 08/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

class RegionJSON : Codable
{
    var region_id : Int
    var name : String
    var description : String?
    var constellations : [Int]
    
    /*
    init(region_id : Int, name : String, description : String?, constellations : Constellations) {
        self.region_id = region_id
        self.name = name
        self.description = description
        self.constellations = constellations
    }
    */
}
