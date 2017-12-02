//
//  ScrollView.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public let nc = NotificationCenter.default

public var focusOnSystem : Int = -1 {
    willSet(newSystemIndex) {
        print("About to set system index to \(newSystemIndex)")
        nc.post(name: Notification.Name("focusToSystem"), object: nil)
    }
}

class ScrollView: UIScrollView {

    override func draw(_ rect: CGRect) {
        print("SCROLLVIEW")
        
        // Set up local notifications.
        //let nc = NotificationCenter.default
        //nc.post(name: Notification.Name("focusToSystem"), object: nil)
        nc.addObserver(self, selector: #selector(focusToSystem), name: Notification.Name("focusToSystem"), object: nil)
        
        //  Set map initial focus.
        setContentOffset(CGPoint(x: origin, y: origin), animated: false)
    }

    @objc func focusToSystem() {
        NSLog("notification triggered")
        setContentOffset(CGPoint(x: Systems[currentSystemIndex].posX, y: Systems[currentSystemIndex].posY), animated: false)
    }
}
