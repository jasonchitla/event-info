//
//  Festival.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import Foundation

struct Festival {
    let name:String
    var lineup = [Band]()
    var biography: String = ""
    
    init (name: String) {
        // set name
        self.name = name
    }
}

struct Band {
    let url:NSURL?
    let name:String
}

