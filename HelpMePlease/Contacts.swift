//
//  Contacts.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 3/31/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import Foundation
import CoreData

class Contacts: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var phone: String

}
