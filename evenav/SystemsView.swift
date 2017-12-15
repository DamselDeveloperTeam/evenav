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
public var RegionLabels = [RegionLabel]()

class SystemsView: UIView {
    var newLabel = SystemLabel() as SystemLabel
    var conLabel = ConstellationLabel() as ConstellationLabel
    var regLabel = RegionLabel() as RegionLabel

    override func draw(_ rect: CGRect) {
        NSLog("UIVIEW")
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        
        //  Appending regions, constellations, systems and connectors to their respective arrays.
        //NSLog("Populating region array...");
        messageString = "Populating region array..."
        nc.post(name: Notification.Name("loadingMessage"), object: nil)
        DataBase.sharedInstance.CreateRegionArray()
        //NSLog("Populating constellation array...");
        messageString = "Populating constellation array..."
        nc.post(name: Notification.Name("loadingMessage"), object: nil)
        DataBase.sharedInstance.CreateConstellationsArray()
        //NSLog("Populating system array...");
        messageString = "Populating system array..."
        nc.post(name: Notification.Name("loadingMessage"), object: nil)
        DataBase.sharedInstance.CreateSystemsArray()
        //NSLog("Populating connection array...");
        messageString = "Populating connection array..."
        nc.post(name: Notification.Name("loadingMessage"), object: nil)
        DataBase.sharedInstance.CreateConnectorArray();
        
        //  When drawing, order matters; first drawn will be overwritten by any objects to be drawn later.
        //
        //  Drawing region labels.
        NSLog("Drawing \(RegionLabels.count) region labels...");
        for rIX in 0 ... RegionLabels.count - 1 {
            regLabel = RegionLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 640, height: 64))
            regLabel.text = RegionLabels[rIX].name
            regLabel.center = CGPoint(x: RegionLabels[rIX].posX, y: RegionLabels[rIX].posY)
            self.addSubview(regLabel)
        }

        //  Drawing constellation labels.
        NSLog("Drawing \(Constellations.count) constellation labels...");
        for cIX in 0 ... Constellations.count - 1 {
            //conLabel = ConstellationLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 240, height: 24))
            conLabel = ConstellationLabel(frame: CGRect(x: Constellations[cIX].pX / 2, y: Constellations[cIX].pY / 2, width: 240, height: 24))
            conLabel.text = Constellations[cIX].name
            conLabel.center = CGPoint(x: Constellations[cIX].pX, y: Constellations[cIX].pY)
            self.addSubview(conLabel)
        }
        
        //  Drawing connectors between systems according to Connectors array.
        var n: Int = 0;
        NSLog("Drawing \(Connectors.count) connections...");
        for ix in 0 ... Connectors.count - 1 {
            n += 1;
            //NSLog("Drew connection: \(n)")
            Connectors[ix].plot()
        }

        //  Drawing systems and their names according to Systems array.
        //  Coordinates in Systems array are relative to constellation coordinates.
        NSLog("Drawing \(Systems.count) systems...");
        for ix in 0 ... Systems.count - 1 {
            //  Drawing system.
            Systems[ix].draw(CGRect(x: Systems[ix].posX, y: Systems[ix].posY, width: systemButtonSize, height: systemButtonSize))

            //  Drawing system name.
            newLabel = SystemLabel(frame: CGRect(x: self.frame.size.width / 2, y: self.frame.size.height / 2, width: 150, height: 15))
            newLabel.text = Systems[ix].name
            newLabel.center = CGPoint(x: Systems[ix].posX + (systemButtonSize / 2), y: Systems[ix].posY + 18)
            self.addSubview(newLabel)
        }
        NSLog("...all drawing done.")
    }

}
