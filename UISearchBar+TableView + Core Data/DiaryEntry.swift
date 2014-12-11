//
//  DiaryEntry.swift
//  UISearchBar+TableView + Core Data
//  UISearchBar+TableView + Core Data
//
//  Created by Alex Gibson on 12/11/14.
//  Copyright (c) 2014 Alex Gibson . All rights reserved.
//

import UIKit

class DiaryEntry: NSObject {
    
    var title : NSString
    var date : NSString
    var entry : NSString
    
    init(title : String, date : String,  entry : String) {
        
        self.title = title
        self.date = date
        self.entry = entry
        
    }
}
