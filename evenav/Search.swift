//
//  SystemSearch.swift
//  evenav
//
//  Created by Koulutus on 29/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//
//  Module contains functions for searching constellations and systems with their name or id.
//

import Foundation

//  Locate constellation id from Constellations table and return index.
public func locateConstellationIdByIndex(constellationIdToSearch: Int) -> Int {
    var foundIndex : Int = -1
    
    for ix in 0 ... Constellations.count - 1 {
        if Constellations[ix].id == constellationIdToSearch {
            foundIndex = ix
            return (foundIndex)
        }
    }
    return (foundIndex)
}

//  Locate constellation name from Constellations table and return index.
public func locateConstellationIndexByName(constellationNameToSearch: String) -> Int {
    var foundIndex : Int = -1
    let nameToSearch: String = constellationNameToSearch.uppercased()
    
    for ix in 0 ... Constellations.count - 1 {
        if Constellations[ix].name.uppercased() == nameToSearch {
            foundIndex = ix
            return (foundIndex)
        }
    }
    return (foundIndex)
}

//  Locate system name from Systems table and return index.
public func locateSystemIndex(systemNameToSearch: String) -> Int {
    var foundIndex : Int = -1
    let nameToSearch: String = systemNameToSearch.uppercased()
    
    for ix in 0 ... Systems.count - 1 {
        if Systems[ix].name.uppercased() == nameToSearch {
            foundIndex = ix
            return (foundIndex)
        }
    }
    return (foundIndex)
}

//  Locate system Id from Systems table and return index.
public func locateSystemById(systemIdToSearch: Int) -> Int {
    var foundIndex : Int = -1
    
    for ix in 0 ... Systems.count - 1 {
        if Systems[ix].id == systemIdToSearch {
            foundIndex = ix
            return (foundIndex)
        }
    }
    return (foundIndex)
}
