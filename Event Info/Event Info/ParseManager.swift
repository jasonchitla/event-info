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
    
    // MARK: Network Configuration
    private static let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    private let session = NSURLSession(configuration: sessionConfig)
    
    // MARK: Completion Handler aliases
    typealias SongkickParseCompletion = (bands: [Band], error: String?) -> ()
    typealias FrontGateParseCompletion = (eventBiography: String?, error: String?) -> ()
    
    // MARK: Initialization
    // private init because it's a singleton
    private init() {}

    // MARK: Scrape calls
    
    // fetches lineup from songkick
    func parseSongkickFestivalURL(url: NSURL, completion: SongkickParseCompletion) {
        let urlRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                completion(bands: [], error: "Error: could not ping url")
                return
            }
            
            guard let responseData = data else {
                completion(bands: [], error: "Error: did not receive data")
                return
            }
            
            let parser:TFHpple = TFHpple(HTMLData: responseData)
            let lineupPath:String = "//div[@class='line-up']/ul/li"
            let lineupRawData:[AnyObject] = parser.searchWithXPathQuery(lineupPath)
            var lineup = [Band]()
            
            if !lineupRawData.isEmpty {
                for element in lineupRawData {
                    lineup += [Band(url: NSURL(string: self.SONGKICK + element.firstChild!.objectForKey("href")), name: element.firstChild!.content)]
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completion(bands: lineup, error: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(bands: [], error: "no lineup exists on songkick")
                })
            }
        }
        task.resume()
    }
    
    // fetches event bio from frontgate
    func parseFrontGateFestivalURL(url: NSURL, completion: FrontGateParseCompletion) {
        let urlRequest = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                completion(eventBiography: nil, error: "Error: could not ping url")
                return
            }
            
            guard let responseData = data else {
                completion(eventBiography: nil, error: "Error: did not receive data")
                return
            }
            
            let parser:TFHpple = TFHpple(HTMLData: responseData)
            let eventBiographyPath:String = "//div[@class='article-main-content']/section[@class='entry-content']/h4"
            let eventBiographyRawData:[AnyObject] = parser.searchWithXPathQuery(eventBiographyPath)
            
            if !eventBiographyRawData.isEmpty {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(eventBiography: eventBiographyRawData[0].content, error: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(eventBiography: nil, error: "no bio exists on front gate")
                })
            }
        }
        task.resume()
    }

}