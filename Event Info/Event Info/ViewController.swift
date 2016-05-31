//
//  ViewController.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SONGKICK: String = "http://www.songkick.com"
    var bandArray = [Band]()
    
    struct Band {
        let url:NSURL?
        let name:String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Parse
        parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parse() {
        guard let url:NSURL = NSURL(string: "https://www.songkick.com/festivals/1234-bonnaroo-music/id/24754599-bonnaroo-music-festival-2016") else {
            return
        }
        guard let data:NSData = NSData(contentsOfURL: url) else {
            return
        }
        let parser:TFHpple = TFHpple(HTMLData: data)
        let tutorialsString:String = "//div[@class='line-up']/ul/li"
        let array:[AnyObject] = parser.searchWithXPathQuery(tutorialsString)
        
        for element in array {
            bandArray += [Band(url: NSURL(string: SONGKICK + element.firstChild!.objectForKey("href")), name: element.firstChild!.content)]
        }
        
        for band in bandArray {
            print(band.name)
            if let url = band.url {
                print(url)
            }
        }
    }

}

