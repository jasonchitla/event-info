//
//  ViewController.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var festival:Festival = Festival(name: "Bonnaroo", lineup: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parse()
    }
    
    func parse() {
        // URL
        let url:NSURL? = NSURL(string: "https://www.songkick.com/festivals/1234-bonnaroo-music/id/24754599-bonnaroo-music-festival-2016")
        
        // Parse
        if let url = url {
            ParseManager.sharedInstance.parseSongkickFestivalURLToFetchLineUp(url) {
                (result, error) -> () in
                guard error == nil else {
                    // alert of error
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

}

