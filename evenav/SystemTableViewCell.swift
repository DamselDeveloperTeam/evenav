//
//  SystemTableViewCell.swift
//  eve
//
//  Created by Koulutus on 14/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class SystemTableViewCell: UITableViewCell {

    @IBOutlet weak var systemIDLabel: UILabel!
    @IBOutlet weak var systemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
