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
    
    /*
    func systemButtonClicked(sender: UIButton) {
        NSLog("System Button clicked!");
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        //self.addTarget(getCurrentViewController(), action: #selector(getCurrentViewController().systemButtonClicked(_:)), for: UIControlEvents.allTouchEvents);
        //self.tag = 999;
        //self.addTarget(getCurrentViewController(), action: #selector(getCurrentViewController().systemButtonClicked(sender:)), for: UIControlEvents.allTouchEvents);
        //self.isUserInteractionEnabled = true;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        
        switch color {
        case UIColor.blue:
            UIColor.blue.withAlphaComponent(0.6).set()
        case UIColor.red:
            UIColor.red.withAlphaComponent(0.3).set()
        default:
            UIColor.white.withAlphaComponent(0.6).set()
        }

        path.fill()
        path.close()
    }
    
}
