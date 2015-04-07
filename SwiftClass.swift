//
//  SwiftClass.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 4/7/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import Foundation

class CheckForHelp : PFObject, PFSubclassing {
    @NSManaged var displayName: String
    
    override class func load() {
        self.registerSubclass()
    }
    class func parseClassName() -> String! {
        return "Armor"
    }
}