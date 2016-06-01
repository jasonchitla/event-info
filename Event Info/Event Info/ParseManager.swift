//
//  ParseManager.swift
//  Event Info
//
//  Created by Jason Chitla on 5/31/16.
//  Copyright © 2016 Jason Chitla. All rights reserved.
//

import Foundation

final class ParseManager {
    
    // MARK: Properties
    static let sharedInstance = ParseManager()
    
    // MARK: Constants
    private let SONGKICK: String = "http://www.songkick.com"
    
    // MARK: Completion Handler aliases
    typealias SongkickParseCompletion = (bands: [Band], error: String?) -> ()
    typealias FrontGateParseCompletion = (eventBiography: String?, error: String?) -> ()
    
    // MARK: Initialization
    // private init because it's a singleton
    private init() {}

    // MARK: Scrape calls
    
    // fetches lineup from songkick
    func parseSongkickFestivalURL(url: NSURL, completion: SongkickParseCompletion) {
        guard let data:NSData = NSData(contentsOfURL: url) else {
            completion(bands: [], error: "Error")
            return
        }
        
        let parser:TFHpple = TFHpple(HTMLData: data)
        let lineupPath:String = "//div[@class='line-up']/ul/li"
        let lineupRawData:[AnyObject] = parser.searchWithXPathQuery(lineupPath)
        var lineup = [Band]()
        
        for element in lineupRawData {
            lineup += [Band(url: NSURL(string: SONGKICK + element.firstChild!.objectForKey("href")), name: element.firstChild!.content)]
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            completion(bands: lineup, error: nil)
        })
    }
    
    // fetches event bio from frontgate
    func parseFrontGateFestivalURL(url: NSURL, completion: FrontGateParseCompletion) {
        guard let data:NSData = NSData(contentsOfURL: url) else {
            completion(eventBiography: nil, error: "Error")
            return
        }
        
        let parser:TFHpple = TFHpple(HTMLData: data)
        let eventBiographyPath:String = "//div[@class='article-main-content']/section[@class='entry-content']/h4"
        let eventBiographyRawData:[AnyObject] = parser.searchWithXPathQuery(eventBiographyPath)
        
        dispatch_async(dispatch_get_main_queue(), {
            completion(eventBiography: eventBiographyRawData[0].content, error: nil)
        })
    }

}