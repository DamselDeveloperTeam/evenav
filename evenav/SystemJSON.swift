//
//  System.swift
//  eve
//
//  Created by Koulutus on 08/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

class SystemJSON : Codable
{
    var star_id : Int
    var system_id : Int
    var name : String
    var position : Position
    var security_status: Double
    var security_class : String?
    var constellation_id: Int
    var planets : [SystemPlanets]?
    var stargates : [Int]? //merely a list of integers, so no need to process as Stargates class
    var stations : [Int]? // see above, this time for Stations class
    
    /*
    init(star_id : Int, system_id : Int, name : String, position : Position, security_status : Double, security_class : String?, constellation_id : Int, planets : Planets, stargates : Stargates?, stations : Stations?)
    {
        self.star_id = star_id
        self.system_id = system_id
        self.name = name
        self.position = position
        self.security_status = security_status
        self.security_class = security_class
        self.constellation_id = constellation_id
        self.planets = planets
        self.stargates = stargates
        self.stations = stations
    }
    */
}

// custom made class made to handle specific Planet class data
// inside System class, in this case planet_id...moon data is
// not needed so it is discarded
class SystemPlanets : Codable
{
    var planet_id : Int
}
