//
//  DebugClasses.swift
//  tmdl
//
//  Created by Koulutus on 22/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

public func FakeSystemsGenerator() {
    var tempX : Int = 0
    var tempY : Int = 0
    var tempT : Int = 0
    let tempC : Int = 100  // Number of systems to generate.
    let tempB : Int = 4080  // Drawing boundary. Half of the map widht/height.
    print("FAKING")
    
    //  Appending system locations to Systems array.
    for ix in 0 ... tempC {
        tempX = Int(arc4random_uniform(UInt32(tempB)))
        tempY = Int(arc4random_uniform(UInt32(tempB)))
        
        tempT = Int(arc4random_uniform(2))
        if tempT == 0 {
            tempX -= tempB
        }
        tempT = Int(arc4random_uniform(2))
        if tempT == 0 {
            tempY -= tempB
        }
        
        Systems.append(SystemButton())
        Systems[ix].posX = origin + tempX; Systems[ix].posY = origin + tempY;
        //  Connection to random system.
        Systems[ix].connectsToSystem.append(
            Int(arc4random_uniform(UInt32(tempC))))
    }
    
    // Appending system connectors to Connectors array.
    for ix in 0 ... Systems.count - 1 {
        for iy in 0 ... Systems[ix].connectsToSystem.count - 1 {
            let NewSystemConnector = SystemConnector()
            let targetSystem = Systems[ix].connectsToSystem[iy]
            NewSystemConnector.sourceX = Systems[ix].posX
            NewSystemConnector.sourceY = Systems[ix].posY
            NewSystemConnector.targetX = Systems[targetSystem].posX
            NewSystemConnector.targetY = Systems[targetSystem].posY
            NewSystemConnector.gateType = 0
            Connectors.append(NewSystemConnector)
        }
    }
    print("FAKED")
}

//  Scraps.
/*
 let SourcePoint = CGPoint(x: sourceX, y: sourceY)
 let TargetPoint = CGPoint(x: targetX, y: targetY)
 let ConnectionVector = CGVector(dx: TargetPoint.x - SourcePoint.x, dy: TargetPoint.y - SourcePoint.y) // Vector from A to B
 print(ConnectionVector) // CGVector(dx: 5.0, dy: 5.0)
 */

