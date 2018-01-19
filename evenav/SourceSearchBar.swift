//
//  SourceSearchBar.swift
//  evenav
//
//  Created by Koulutus on 04/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class SourceSearchBar: UISearchBar {
    let identifier: String = "Source";
    var selectedSystemID: Int?;
    var isBeingEdited: Bool = false;
}

/*
extension UISearchBar {
    static var testVar: String {
        get {
            return self.testVar;
        }
        set {
            self.testVar = newValue;
        }
    }
}
*/
