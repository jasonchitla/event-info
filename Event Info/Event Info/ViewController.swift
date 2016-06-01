//
//  ViewController.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var festival:Festival = Festival(name: "Bestival", lineup: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseSongkickExample()
        parseFrontGateExample()
    }
    
    func parseSongkickExample() {
        // URL
        let url:NSURL? = NSURL(string: "https://www.songkick.com/festivals/1253518-bestival-toronto/id/26468909-bestival-toronto-2016")
        
        // Parse
        if let url = url {
            ParseManager.sharedInstance.parseSongkickFestivalURL(url) {
                (result, error) -> () in
                guard error == nil else {
                    // alert of error
                    print("Error/ Songkick")
                    return
                }
                self.festival.lineup = result
                for band in self.festival.lineup {
                    print(band.name)
                    if let url = band.url {
                        print(url)
                    }
                }
            }
        }
    }
    
    func parseFrontGateExample() {
        // URL
        let url:NSURL? = NSURL(string: "http://www.frontgatetickets.com/festivals/bestival/")
        
        // Parse
        if let url = url {
            ParseManager.sharedInstance.parseFrontGateFestivalURL(url) {
                (result, error) -> () in
                guard error == nil else {
                    // alert of error
                    print("Error/ Front Gate")
                    return
                }
                if let result = result {
                    print(result)
                }
            }
        }
    }
}

