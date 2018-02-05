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

    var alreadyDrawn: Bool = false;
    
    override func draw(_ rect: CGRect) {
        NSLog("UIVIEW")
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        
        if(nothingToDraw()) {
            return
        }
        
        if (!self.alreadyDrawn) {
            self.drawRegionLabels();
            self.drawConstellationLabels();
            self.drawSystemLabels();
            self.drawSystems();
        }
        self.alreadyDrawn = true;
        
        self.drawConnectors();
        NSLog("...all drawing done.");
        
        //Close LoadingScreen and display MapView.
        self.getCurrentViewController().returnToMapView();
    }
    
    // Draw region labels.
    private func drawRegionLabels() {
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
    }
    
    // Draw constellation labels.
    private func drawConstellationLabels() {
        NSLog("Drawing \(Constellations.count) constellation labels...");
        for cIX in 0 ... Constellations.count - 1 {
            self.conLabel = ConstellationLabel(frame: CGRect(x: 1, y: 1, width: 240, height: 24))
            self.conLabel.text = Constellations[cIX].name
            self.conLabel.center = CGPoint(x: Constellations[cIX].pX, y: Constellations[cIX].pY)
            self.addSubview(self.conLabel)
        }
    }
    
    // Draw system labels.
    private func drawSystemLabels() {
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
    
    // Draw connectors between systems according to Connectors array.
    private func drawConnectors() {
        var n: Int = 0;
        NSLog("Drawing \(Connectors.count) connections...");
        for ix in 0 ... Connectors.count - 1 {
            n += 1;
            //NSLog("Drew connection: \(n)")
            Connectors[ix].plot()
        }
        NSLog("Finished drawing \(Connectors.count) connections...");
    }
    
    // Draw systems and their names according to Systems array.
    private func drawSystems() {
        NSLog("Drawing \(Systems.count) systems...");
        for ix in 0 ... Systems.count - 1 {
            //  Drawing system.
            let sysButton: SystemButton = SystemButton(frame: CGRect(x: Systems[ix].posX, y: Systems[ix].posY, width: systemButtonSize, height: systemButtonSize));
            
            sysButton.tag = Systems[ix].id;
            sysButton.addTarget(getCurrentViewController(), action: #selector(getCurrentViewController().systemButtonClicked(sender:)), for: UIControlEvents.allTouchEvents);
            sysButton.isUserInteractionEnabled = true;
            
            self.addSubview(sysButton);
        }
    }
    
    private func nothingToDraw() -> Bool {
        if (Systems.count == 0 || Connectors.count == 0 || Constellations.count == 0 || RegionLabels.count == 0) {
            return true
        }
        return false
    }
    
    private func getCurrentViewController() -> ViewController {
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController as! ViewController;
        return currentViewController
    }
    
}
