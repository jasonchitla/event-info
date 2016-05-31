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
    typealias CompletionEvent = (festivals: [Festival], error: String?) -> ()
    
    // MARK: Initialization
    // private init because it's a singleton
    private init() {}

    // MARK: Scrape calls
    func parseSongkickURL(url: NSURL, completion: CompletionEvent) {
        guard let data:NSData = NSData(contentsOfURL: url) else {
            completion(festivals: [], error: "Error")
            return
        }
        
        let parser:TFHpple = TFHpple(HTMLData: data)
        let tutorialsString:String = "//div[@class='line-up']/ul/li"
        let array:[AnyObject] = parser.searchWithXPathQuery(tutorialsString)
        var festivalArray = [Festival]()
        
        for element in array {
            festivalArray += [Festival(url: NSURL(string: SONGKICK + element.firstChild!.objectForKey("href")), name: element.firstChild!.content)]
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            completion(festivals: festivalArray, error: nil)
        })
    }

}