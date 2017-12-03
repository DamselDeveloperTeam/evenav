//
//  ScrollView.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public let nc = NotificationCenter.default

class ScrollView: UIScrollView {

    override func draw(_ rect: CGRect) {
        print("SCROLLVIEW")
        
        // Local notification observer for focusToSystem.
        nc.addObserver(self, selector: #selector(focusToSystem), name: Notification.Name("focusToSystem"), object: nil)
        
        //  Set map initial focus.
        setContentOffset(CGPoint(x: origin, y: origin), animated: false)
    }

    @objc func focusToSystem() {
        // Constants for calculating the center of map viewport.
        let screenSize = UIScreen.main.bounds
        let screenWidth : Int = Int(screenSize.width)
        let screenHeight : Int = Int(screenSize.height)
        let verticalOffset : Int = TopBarHeight / 2
        
        //setContentOffset(CGPoint(x: Systems[currentSystemIndex].posX, y: Systems[currentSystemIndex].posY), animated: true)
        setContentOffset(CGPoint(x: Systems[currentSystemIndex].posX - (Int(screenWidth) / 2), y: Systems[currentSystemIndex].posY + verticalOffset - (Int(screenHeight) / 2)), animated: true)
    }
}
