//
//  SystemSearch.swift
//  evenav
//
//  Created by Koulutus on 29/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import Foundation

//  Locate system name from Systems table and return index.
public func locateSystemIndex(systemNameToSearch: String) -> Int {
    var foundIndex : Int = -1
    
    for ix in 0 ... Systems.count - 1 {
        if Systems[ix].name == systemNameToSearch {
            foundIndex = ix
            return (foundIndex)
        }
    }
    return (foundIndex)
}
