//
//  SystemDataManager.swift
//  eve
//
//  Created by Koulutus on 21/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//
// Needed files in order for this to work:
// - SystemDataManager.swift (this file)
// - Position.swift
// - System.swift
// - system.json
// - (ViewController.swift for calling "SystemDataManager.readJSON()")

import Foundation

class SystemDataManager
{
    public static func readJSON()
    {
        DispatchQueue.global(qos: .background).async {
            let filePath = Bundle.main.path(forResource: "system", ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            
            do
            {
                NSLog("reading json data...")
                let data = try Data(contentsOf: url)
                NSLog("reading json data done")
            
                NSLog("decoding json data...")
                let decoder = JSONDecoder()
                let systems = try decoder.decode([SystemJSON].self, from: data)
                NSLog("decoding json data done")
                
                NSLog("Adding systems to DB...")
                for system in systems
                {
                    let xpos = Int(round(system.position.x/1000000000000))
                    let ypos = Int(round(system.position.y/1000000000000))
                    let zpos = Int(round(system.position.z/1000000000000))

                    //NSLog(system.star_id.description + ", " + system.name + ": " + xpos.description + ", " +  ypos.description + ", " +  zpos.description)
                    
                    var result: Bool;
                    if !checkStringFormat(inputString: system.name) {
                        result = DataBase.sharedInstance.addSystem(system: System(id: system.system_id,
                                                                     name: system.name,
                                                                     pX: xpos,
                                                                     pY: ypos,
                                                                     pZ: zpos));
                    
                        if result == false {
                            NSLog(system.star_id.description + ", " + system.name + ": " + xpos.description + ", " +  ypos.description + ", " +  zpos.description)
                        }
                    }
                    
                }
                NSLog("Adding systems to DB finished")
                
                /*
                NSLog("Adding connections to DB...")
                var result: Bool;
                let conFinder = ConnectionFinder();
                //let connections: [Int] = [];
                for system in systems {
                    if let connections = conFinder.findConnectionsFor(systemID: system.system_id) {
                        for con in connections {
                            result = DataBase.sharedInstance.addConnection(from: system.system_id, to: con);
                        }
                    }
                    else {
                        NSLog("Connections not found for: \(system.name)(\(system.star_id))");
                    }
                }
                
                
                NSLog("Adding connections to DB finished")
                */
                
                
            }
            catch let error as NSError
            {
                NSLog(error.debugDescription)
            }
        }
    }
    
    static func checkStringFormat ( inputString : String ) -> Bool {
        
        if inputString.count != 7
            
        {
            
            return false
            
        }
        
        
        
        for (iter, element) in inputString.enumerated() {
            
            if iter == 0 {
                
                if element != "J" {
                    
                    return false
                    
                }
                
            }
                
            else if iter > 0 {
                
                if (element >= "0") && (element <= "9") {
                    
                }
                    
                else {
                    
                    return false
                    
                }
                
            }
                
            else { }
            
        }
        
        
        
        return true
        
    }
    
        /*
            print(decodedMsg[0].star_id.description + ", " + decodedMsg[0].name + ": ")
            print(String(Int(decodedMsg[0].position.x)) + " = " + String(decodedMsg[0].position.x.description) + ", " + decodedMsg[0].position.y.description + ", " + decodedMsg[0].position.z.description)
        */
}
