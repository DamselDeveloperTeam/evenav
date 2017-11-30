//
//  ScrollView.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    override func draw(_ rect: CGRect) {
        print("SCROLLVIEW")

        //  Set map focus.
        setContentOffset(CGPoint(x: origin, y: origin), animated: false)
    }

}
