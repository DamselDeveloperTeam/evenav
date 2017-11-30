//
//  SystemLabel.swift
//  evenav
//
//  Created by Koulutus on 28/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class SystemLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    func initializeLabel() {
        self.textAlignment = .center
        self.font = UIFont(name: "Helvetica", size: 12)
        self.textColor = UIColor.white
    }
}
