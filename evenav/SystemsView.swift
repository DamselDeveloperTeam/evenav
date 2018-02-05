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

    var createArrays: Bool = true;
    
    override func draw(_ rect: CGRect) {
        NSLog("UIVIEW")
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        
        if (Systems.count == 0 || Connectors.count == 0 || Constellations.count == 0 || RegionLabels.count == 0) {
            return
        }
        
        if (self.createArrays) {
            //  When drawing, order matters; first drawn will be overwritten by any objects to be drawn later.
            //
            //  Drawing region labels.
            NSLog("Drawing \(RegionLabels.count) region labels...");
            for rIX in 0 ... RegionLabels.count - 1 {
                self.regLabel = RegionLabel(frame: CGRect(x: 1, y: 1, width: 640, height: 64))
                self.regLabel.text = RegionLabels[rIX].name
                self.regLabel.center = CGPoint(x: RegionLabels[rIX].posX + RegionLabels[rIX].labelX, y: RegionLabels[rIX].posY + RegionLabels[rIX].labelY)
                self.addSubview(self.regLabel)
                if regLabel.text == "Deklein" {
                    print(regLabel.text!, regLabel.center, "x:", RegionLabels[rIX].posX, "y:", RegionLabels[rIX].posY)
                }
            }
            /*for rIX in 0 ... RegionLabels.count - 1 {
                self.regLabel = RegionLabel(frame: CGRect(x: 1, y: 1, width: 640, height: 64))
                self.regLabel.text = RegionLabels[rIX].name
                self.regLabel.center = CGPoint(x: RegionLabels[rIX].posX, y: RegionLabels[rIX].posY)
                self.addSubview(self.regLabel)
                if regLabel.text == "Deklein" {
                    print(regLabel.text!, regLabel.center, "x:", RegionLabels[rIX].posX, "y:", RegionLabels[rIX].posY)
                }
            }*/

            //  Drawing constellation labels.
            NSLog("Drawing \(Constellations.count) constellation labels...");
            for cIX in 0 ... Constellations.count - 1 {
                self.conLabel = ConstellationLabel(frame: CGRect(x: 1, y: 1, width: 240, height: 24))
                self.conLabel.text = Constellations[cIX].name
                self.conLabel.center = CGPoint(x: Constellations[cIX].pX, y: Constellations[cIX].pY)
                self.addSubview(self.conLabel)
            }

            //  Drawing system labels.
            NSLog("Drawing \(Systems.count) system labels...");
            for ix in 0 ... Systems.count - 1 {
                self.newLabel = SystemLabel(frame: CGRect(x: 1, y: 1, width: 150, height: 11))
                self.newLabel.text = Systems[ix].name
                self.newLabel.center = CGPoint(x: Systems[ix].posX + (systemButtonSize / 2), y: Systems[ix].posY + 12)
                self.addSubview(self.newLabel)
                if newLabel.text == "RO0-AF" {
                    print(newLabel.text!, newLabel.center)
                }
            }
        }
        self.createArrays = false;

        //  Drawing connectors between systems according to Connectors array.
        var n: Int = 0;
        NSLog("Drawing \(Connectors.count) connections...");
        for ix in 0 ... Connectors.count - 1 {
            n += 1;
            //NSLog("Drew connection: \(n)")
            Connectors[ix].plot()
        }
        NSLog("Finished drawing \(Connectors.count) connections...");
        
        //  Drawing systems and their names according to Systems array.
        //  Coordinates in Systems array are relative to constellation coordinates.
        NSLog("Drawing \(Systems.count) systems...");
        for ix in 0 ... Systems.count - 1 {
            //  Drawing system.
            //Systems[ix].draw(CGRect(x: Systems[ix].posX, y: Systems[ix].posY, width: systemButtonSize, height: systemButtonSize))
            
            self.addSubview(SystemButton(frame: CGRect(x: Systems[ix].posX, y: Systems[ix].posY, width: systemButtonSize, height: systemButtonSize)));
            
            
        }
        NSLog("...all drawing done.")
        
        self.getCurrentViewController().returnToMapView();
    }
    
    private func getCurrentViewController() -> ViewController {
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController as! ViewController;
        return currentViewController
    }
    
}
