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
        print("ABOUT TO CHANGE FESTIVALS ARRAY TO:")
        for festival in newPropertyValue {
            print(festival.name)
            for band in festival.lineup {
                print(band.name)
            }
            if let biography = festival.biography {
                print("BIOGRAPHY: " + biography)
            }
            print("***********************************")
        }
    }
    
    func didChangeDataStoreFestivalsArray(oldPropertyValue: [Festival]) {
        print("FESTIVALS ARRAY CHANGED FROM:")
        if oldPropertyValue.isEmpty {
            print("nothing was in the array before the change!")
        } else {
            for festival in oldPropertyValue {
                print(festival.name)
                for band in festival.lineup {
                    print(band.name)
                }
                if let biography = festival.biography {
                    print("BIOGRAPHY: " + biography)
                }
                print("***********************************")
            }
        }
    }
}

