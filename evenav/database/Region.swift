//
//  Region.swift
//  EveDatabase
//
//  Copyright © 2017 ?. All rights reserved.
//

import Foundation

class Region {
    let id: Int;
    let name: String;
    let description: String;
    
    init(id: Int, name: String, description: String) {
        self.id = id;
        self.name = name;
        self.description = description;
    }
}
