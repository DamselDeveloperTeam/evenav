//
//  RegionDataManager.swift
//  eve
//
//  Created by Koulutus on 05/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//
// Needed files in order for this to work:
// - RegionDataManager.swift (this file)
// - Region.swift
// - region.json
// - (ViewController.swift for calling "RegionDataManager.readJSON()")

import Foundation

class RegionDataManager
{
    public static func readJSON() //-> [Region]
    {
        DispatchQueue.global(qos: .background).async {
            let filePath = Bundle.main.path(forResource: "region", ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            
            do
            {
                NSLog("reading json data...")
                let data = try Data(contentsOf: url)
                NSLog("reading json data done")
                
                NSLog("decoding json data...")
                let decoder = JSONDecoder()
                let regions = try decoder.decode([RegionJSON].self, from: data)
                NSLog("decoding json data done")
                
                NSLog("adding regions to DB started");
                
                for region in regions
                {
                    //DataBase.sharedInstance.addRegion(region: Region(id: region.region_id, name: region.name, description: "null"));
                    
                    for constid in region.constellations {
                        DataBase.sharedInstance.addConstellationToRegion(constellationID: constid, regionID: region.region_id);
                    }
                }
                
                NSLog("adding regions to DB finished");
            
                
            } catch let error as NSError
            {
                NSLog(error.debugDescription)
            }
        }
    }
}
