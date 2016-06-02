//
//  ViewController.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataStoreObserverProtocol {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataStore.sharedInstance.observer = self
    }
    
    // MARK: DataStoreObserverProtocol functions
    func willChangeDataStoreFestivalsArray(newPropertyValue: [Festival]) {
        print("ABOUT TO CHANGE FESTIVALS ARRAY")
        for festival in newPropertyValue {
            print(festival.name)
            for band in festival.lineup {
                print(band.name)
            }
            print(festival.biography)
            print("***********************************")
        }
    }
    
    func didChangeDataStoreFestivalsArray(oldPropertyValue: [Festival]) {
        print("FESTIVALS ARRAY CHANGED")
        for festival in oldPropertyValue {
            print(festival.name)
            for band in festival.lineup {
                print(band.name)
            }
            print(festival.biography)
            print("***********************************")
        }
    }
}

