//
//  SystemConnector.swift
//  tmdl
//
//  Created by Koulutus on 22/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public class SystemConnector: UIBezierPath {
    lazy var connection_id = [Int]()
    lazy var sourceX : Int = 0
    lazy var sourceY : Int = 0
    lazy var targetX : Int = 0
    lazy var targetY : Int = 0
    //  gate types: 0 = regular, 1 = constellation, 2 = region
    lazy var gateType : Int = 0
    lazy var isHighlighted: Bool = false;
    //lazy var needsRedraw : Bool = true
    
    func plot() {
        //if (!needsRedraw) { return }
        if(isHighlighted) {
            UIColor.yellow.setStroke();
        } else {
            switch self.gateType {
            case 1:
                UIColor.magenta.setStroke()
            case 2:
                UIColor.red.setStroke()
            //case 3: //Route highlight color
            //    UIColor.yellow.setStroke()
            default:
                UIColor.cyan.setStroke()
            }
        }

        move(to: CGPoint(x: sourceX + (systemButtonSize / 2), y: sourceY + (systemButtonSize / 2)))
        addLine(to: CGPoint(x: targetX + (systemButtonSize / 2), y: targetY + (systemButtonSize / 2)))
        stroke(with: CGBlendMode.normal, alpha: 0.7)
        //needsRedraw = false
    }
}
