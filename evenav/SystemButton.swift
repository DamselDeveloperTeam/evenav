//
//  SystemButton.swift
//  tmdl
//
//  Created by Koulutus on 21/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public class SystemButton: UIButton {
    var id: Int = 0
    var color: UIColor = UIColor.white
    var name: String = ""
    var posX: Int = 0
    var posY: Int = 0
    var posZ: Int = 0
    var constellation: Int = 0
    var region: Int = 0
    var connectsToSystem = [Int]()
    var securityStatus: Double = 0.0;
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        
        switch color {
        case UIColor.blue:
            UIColor.blue.set()
            NSLog("USING BLUE")
        default:
            UIColor.white.set()
        }

        path.fill()
        path.close()
    }
}
