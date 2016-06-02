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
        
        // set lineup
        /*if let url = NSURL(string: dictionary["SongkickURL"]!) {
            ParseManager.sharedInstance.parseSongkickFestivalURL(url, completion: {
                (result, error) -> () in
                guard error == nil else {
                    // alert of error
                    print("Error/ Songkick")
                    return
                }
                self.lineup = result
            })
        }
        
        // set bio
        if let url = NSURL(string: dictionary["FrontGateURL"]!) {
            ParseManager.sharedInstance.parseFrontGateFestivalURL(url, completion: {
                (result, error) -> () in
                guard error == nil else {
                    // alert of error
                    print("Error/ FrontGate")
                    return
                }
                
                if let result = result {
                    self.biography = result
                }
            })
        }*/
    }
}

struct Band {
    let url:NSURL?
    let name:String
}

