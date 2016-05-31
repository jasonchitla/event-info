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
    var lineup:[Band]
}

struct Band {
    let url:NSURL?
    let name:String
}