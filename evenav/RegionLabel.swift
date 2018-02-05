//
//  RegionLabel.swift
//  evenav
//
//  Created by Koulutus on 12/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

public class RegionLabel: UILabel {
    var id: Int = 0
    var name: String = ""
    var posX: Int = 0
    var posY: Int = 0
    var posZ: Int = 0
    var labelX: Int = 0
    var labelY: Int = 0

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
        self.font = UIFont(name: "Helvetica-Bold", size: 64)
        self.textColor = UIColor.orange.withAlphaComponent(0.5)
        //self.textColor = UIColor.white.withAlphaComponent(0.04)
        self.isOpaque = true
    }
}
