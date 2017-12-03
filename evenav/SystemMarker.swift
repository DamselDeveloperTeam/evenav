//
//  SystemMarker.swift
//  evenav
//
//  Created by Koulutus on 03/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class SystemMarker: UIButton {

    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
    }
}
