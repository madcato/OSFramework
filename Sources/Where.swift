//
//  Where.swift
//  OSFramework
//
//  Created by Daniel Vela on 22/06/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation
import CoreData

struct Where {
    var predicate: NSPredicate

    init(predicate: String, arguments: [Any]?) {
        self.predicate = NSPredicate(format: predicate, argumentArray: arguments)
    }
}
