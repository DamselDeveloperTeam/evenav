//
//  ConstellationDataManager.swift
//  eve
//
//  Created by Koulutus on 05/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//
// Needed files in order for this to work:
// - ConstellationDataManager.swift (this file)
// - Position.swift
// - Constellation.swift
// - constellation.json
// - (ViewController.swift for calling "ConstellationDataManager.readJSON()")

import Foundation

class ConstellationDataManager
{
    public static func readJSON() //-> [Constellation]
    {
        DispatchQueue.global(qos: .background).async {
            let filePath = Bundle.main.path(forResource: "constellation", ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            
            do
            {
                NSLog("reading json data...")
                let data = try Data(contentsOf: url)
                NSLog("reading json data done")
                
                NSLog("decoding json data...")
                let decoder = JSONDecoder()
                let constellations = try decoder.decode([ConstellationJSON].self, from: data)
                NSLog("decoding json data done")
                
                NSLog("adding constellations to DB started");
                
                for constellation in constellations
                {
                    // rounding positioning to a more processable format
                    let xpos = Int(round(constellation.position.x/1000000000000))
                    let ypos = Int(round(constellation.position.y/1000000000000))
                    let zpos = Int(round(constellation.position.z/1000000000000))
                    
                    //DataBase.sharedInstance.addConstellation(constellation: Constellation(id: constellation.constellation_id, name: constellation.name, region: constellation.region_id, pX: xpos, pY: ypos, pZ: zpos));
                    
                    for sysid in constellation.systems {
                        DataBase.sharedInstance.addSystemToConstellation(systemID: sysid, constellationID: constellation.constellation_id);
                    }

                }
                
                
                NSLog("adding constellations to DB finished");

                
            } catch let error as NSError
            {
                NSLog(error.debugDescription)
            }
        }
    }
}
