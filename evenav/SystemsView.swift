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
public var Constellations = [ConstellationLabel]()

class SystemsView: UIView {
    var newLabel = SystemLabel() as SystemLabel
    var conLabel = ConstellationLabel() as ConstellationLabel

    override func draw(_ rect: CGRect) {
        NSLog("UIVIEW")
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        
        //  Appending constellations, systems and connectors to their respective arrays.
        DataBase.sharedInstance.CreateConstellationsArray()
        DataBase.sharedInstance.CreateSystemsArray()
        DataBase.sharedInstance.CreateConnectorArray();
        
        //  When drawing, order matters; first drawn will be overwritten by any objects to be drawn later.
        //
        //  Drawing constellation labels.
        for cIX in 0 ... Constellations.count - 1 {
            conLabel = ConstellationLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 320, height: 48))
            conLabel.text = Constellations[cIX].name
            conLabel.center = CGPoint(x: Constellations[cIX].pX, y: Constellations[cIX].pY)
            self.addSubview(conLabel)
        }
        
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
/*
        NSLog("Printing constellation data for all systems...")
        for i in 0 ... Systems.count - 1 {
            if let constellation = DataBase.sharedInstance.getConstellationData(constellationID: Systems[i].constellation) {
                NSLog("\(constellation.name) (\(constellation.id)) [\(constellation.pX), \(constellation.pY), \(constellation.pZ)]");
            }
        }
 */
    }

/*
    func drawConstellations() {
        //  Getting constellation coordinates.
        var conX : Int = 0
        var conY : Int = 0
        //var conZ : Int = 0
        if let thisConstellation = DataBase.sharedInstance.getConstellationData(constellationID: Systems[ix].constellation) {
            //NSLog(thisConstellation.name)
            conX = origin + (thisConstellation.pX / constellationScale)
            conY = origin - (thisConstellation.pY / constellationScale)
            //conZ = Systems[ix].posY
            //  Drawing constellation name.
            conLabel = SystemLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 300, height: 60))
            conLabel.text = thisConstellation.name
            conLabel.center = CGPoint(x: conX + (systemButtonSize / 2), y: conY + 18)
            conLabel.font = UIFont(name: "Helvetica", size: 32)
            self.addSubview(conLabel)
        } else {
            NSLog("Constellation id", Systems[ix].constellation, "for system", Systems[ix].id, "not found.")
        }
    }
 */
}
