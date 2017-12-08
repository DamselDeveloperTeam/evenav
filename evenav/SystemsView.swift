//
//  SystemsView.swift
//  tmdl
//
//  Created by Koulutus on 21/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public var Systems = [SystemButton]()
public var Connectors = [SystemConnector]()

class SystemsView: UIView {
    var newLabel = SystemLabel() as SystemLabel
    
    override func draw(_ rect: CGRect) {
        print("UIVIEW")
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        
        //  Appending systems and connectors to their respective arrays.
        DataBase.sharedInstance.CreateSystemsArray()
        //DataBase.sharedInstance.CreateConnectionsArray()
        DataBase.sharedInstance.CreateConnectorArray();
        
        //  Drawing connectors between systems according to Connectors array.
        var n: Int = 0;
        NSLog("Drawing connections(size: \(Connectors.count)");
        for ix in 0 ... Connectors.count - 1 {
            n += 1;
            //NSLog("Drew connection: \(n)")
            Connectors[ix].plot()
        }
        NSLog("...done.")

        //  Drawing systems and their names according to Systems array.
        //UIColor.cyan.setStroke()
        NSLog("Drawing systems and system names...")
        for ix in 0 ... Systems.count - 1 {
            //  Drawing system.
            Systems[ix].draw(CGRect(x: Systems[ix].posX, y: Systems[ix].posY, width: systemButtonSize, height: systemButtonSize))
            
            //  Drawing system name.
            newLabel = SystemLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 150, height: 15))
            newLabel.text = Systems[ix].name
            newLabel.center = CGPoint(x: Systems[ix].posX + (systemButtonSize / 2), y: Systems[ix].posY + 18)
            self.addSubview(newLabel)
        }
        NSLog("...done.")
        
        NSLog("Printing constellation data for all systems...")
        for i in 0 ... Systems.count - 1 {
            if let constellation = DataBase.sharedInstance.getConstellationData(constellationID: Systems[i].constellation) {
                NSLog("\(constellation.name) (\(constellation.id)) [\(constellation.pX), \(constellation.pY), \(constellation.pZ)]");
            }
        }
        
    }
}
