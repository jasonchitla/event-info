//
//  DataStore.swift
//  Event Info
//
//  Created by Jason Chitla on 6/2/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import Foundation

final class DataStore {
    
    // MARK: Properties
    static let sharedInstance = DataStore()
    private var store: [String: [String: String]] = [:]
    var observer: DataStoreObserverProtocol?
    private var festivalsArray = [Festival]() {
        willSet(newValue) {
            observer?.willChangeDataStoreFestivalsArray(newValue)
        }
        didSet {
            observer?.didChangeDataStoreFestivalsArray(oldValue)
        }
    }
    
    // MARK: Completion Handler alias
    typealias InitCompletion = (festivals: [Festival], error: String?) -> ()
    
    // MARK: Initialization
    // private init because singleton
    private init() {
        store["Free Press Summer Festival"] = ["SongkickURL":"https://www.songkick.com/festivals/663099-free-press-summer/id/26354774-free-press-summer-festival-2016",
                                                "FrontGateURL":"http://www.frontgatetickets.com/festivals/free-press-summer-festival/"]
        store["Bestival"] = ["SongkickURL":"https://www.songkick.com/festivals/1253518-bestival-toronto/id/26468909-bestival-toronto-2016",
                             "FrontGateURL":"http://www.frontgatetickets.com/festivals/bestival/"]
        store["Bonnaroo"] = ["SongkickURL":"https://www.songkick.com/festivals/1234-bonnaroo-music/id/24754599-bonnaroo-music-festival-2016",
                             "FrontGateURL":"http://www.frontgatetickets.com/festivals/bonnaroo/"]
        store["Big Apple BBQ Block Party"] = ["SongkickURL":"https://www.songkick.com/festivals/1045143-big-apple-barbecue-block-party/id/27082589-big-apple-barbecue-block-party-2016",
                             "FrontGateURL":"http://www.frontgatetickets.com/festivals/big-apple-bbq-block-party/"]
        store["Country Fest"] = ["SongkickURL":"https://www.songkick.com/festivals/104391-country-fest/id/25620544-country-fest-2016",
                             "FrontGateURL":"http://www.frontgatetickets.com/festivals/country-fest/"]
        
        createFestivalsArray({
            (festivals, error) -> () in
            guard error == nil else {
                // alert of error
                print("Error")
                return
            }
            self.festivalsArray = festivals
        })
    }
    
    // fetch all festival info, create each individual festival with that information, and return array with those festivals
    private func createFestivalsArray(completion: InitCompletion) {
        var array = [Festival]()
        
        // create dispatch group
        let festivalCreationGroup = dispatch_group_create()
        
        for (festivalName, dictionary) in store {
            var festival = Festival(name: festivalName)
            
            // fetch lineup
            if let url = NSURL(string: dictionary["SongkickURL"]!) {
                dispatch_group_enter(festivalCreationGroup)
                ParseManager.sharedInstance.parseSongkickFestivalURL(url, completion: {
                    (result, error) -> () in
                    guard error == nil else {
                        // alert of error
                        print("Error/ Songkick")
                        return
                    }
                    festival.lineup = result
                    dispatch_group_leave(festivalCreationGroup)
                })
            }
            
            // fetch bio
            if let url = NSURL(string: dictionary["FrontGateURL"]!) {
                dispatch_group_enter(festivalCreationGroup)
                ParseManager.sharedInstance.parseFrontGateFestivalURL(url, completion: {
                    (result, error) -> () in
                    guard error == nil else {
                        // alert of error
                        print("Error/ FrontGate")
                        return
                    }
                    
                    if let result = result {
                        festival.biography = result
                        dispatch_group_leave(festivalCreationGroup)
                    }
                })
            }
            
            dispatch_group_notify(festivalCreationGroup, dispatch_get_main_queue(), {
                array += [festival]
            })
        }
        dispatch_group_notify(festivalCreationGroup, dispatch_get_main_queue(), {
            dispatch_async(dispatch_get_main_queue(), {
                completion(festivals: array, error: nil)
            })
        })
    }
}

// MARK: Observer protocol
protocol DataStoreObserverProtocol {
    func willChangeDataStoreFestivalsArray(newPropertyValue:[Festival])
    func didChangeDataStoreFestivalsArray(oldPropertyValue:[Festival])
}