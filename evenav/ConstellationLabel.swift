//
//  ConstellationLabel.swift
//  evenav
//
//  Created by Koulutus on 12/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public class ConstellationLabel: UILabel {
    var id: Int = 0
    var name: String = ""
    var region: Int = 0
    var pX: Int = 0
    var pY: Int = 0
    var pZ: Int = 0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    func initializeLabel() {
        self.textAlignment = .center
        self.font = UIFont(name: "Helvetica-Bold", size: 24)
        self.textColor = UIColor.yellow.withAlphaComponent(0.08)
        self.isOpaque = true
    }
}
