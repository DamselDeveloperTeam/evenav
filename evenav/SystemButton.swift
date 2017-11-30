//
//  SystemButton.swift
//  tmdl
//
//  Created by Koulutus on 21/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public class SystemButton: UIButton {
    lazy var id: Int = 0
    lazy var color: UIColor = UIColor.white
    lazy var name: String = ""
    lazy var posX: Int = 0
    lazy var posY: Int = 0
    lazy var posZ: Int = 0
    lazy var constellation: Int = 0
    lazy var region: Int = 0
    lazy var connectsToSystem = [Int]()
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
    }
}
