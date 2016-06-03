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
        // hardcoded list of festivals paired with a songkick url and a front gate url
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
        store["EDC Las Vegas"] = ["SongkickURL":"https://www.songkick.com/festivals/736204-edc-las-vegas/id/26777084-edc-las-vegas-2016",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/edc-las-vegas/"]
        store["Electric Forest Festival"] = ["SongkickURL":"https://www.songkick.com/festivals/183146-electric-forest/id/26087878-electric-forest-festival-2016",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/electric-forest-festival/"]
        store["Digital Dreams"] = ["SongkickURL":"https://www.songkick.com/festivals/413113-digital-dreams/id/26488559-digital-dreams-festival-2016",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/digital-dreams/"]
        store["FVDED in the Park"] = ["SongkickURL":"https://www.songkick.com/festivals/1296473-fvded-in-the-park/id/26555579-fvded-in-the-park-2016",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/fvded-in-the-park/"]
        store["RBC Ottawa Blues Fest"] = ["SongkickURL":"https://www.songkick.com/festivals/1034473-rbc-ottawa-bluesfest/id/26722794-rbc-ottawa-bluesfest-2016",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/rbc-ottawa-blues-fest/"]
        store["Stampede Roundup"] = ["SongkickURL":"https://www.songkick.com/concerts/26840014-moist-at-fort-calgary",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/stampede-roundup/"]
        store["Senseless"] = ["SongkickURL":"https://www.songkick.com/concerts/27098624-senseless-at-evergreen-brick-works",
                     "FrontGateURL":"http://www.frontgatetickets.com/festivals/senseless/"]
        //store[""] = ["SongkickURL":"",
        //             "FrontGateURL":""]
        
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
                        dispatch_group_leave(festivalCreationGroup)
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
                        dispatch_group_leave(festivalCreationGroup)
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