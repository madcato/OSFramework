//
//  SortBy.swift
//  OSFramework
//
//  Created by Daniel Vela on 22/06/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

public class SortBy {
    var sortDescriptors: [NSSortDescriptor]

    // Sample:
    //  - SortBy(["year", "month"])
    //  - SortBy([{"sort": "year", ascending: false}, "month"])
    public init(_ sortArray: [Any]) {
        self.sortDescriptors = SortBy.sortDescriptors(sortArray)
    }

    // Sample:
    //  - SortBy("year")
    public init(_ sortBy: String) {
        self.sortDescriptors = SortBy.sortDescriptors([sortBy])
    }

    private static func sortDescriptors(_ sortArray: [Any]) -> [NSSortDescriptor] {
        var sortDescriptors = [NSSortDescriptor]()
        for element in sortArray {
            if element is String {
                let sortDescriptor = NSSortDescriptor(key: element as? String, ascending: true)
                sortDescriptors.append(sortDescriptor)
            }
            if let ele = element as? [String: Any],
                let ascending = ele["ascending"] as? Bool {
                let sortDescriptor = NSSortDescriptor(key: ele["sort"] as? String,
                                                      ascending: ascending)
                sortDescriptors.append(sortDescriptor)
            }
        }
        return sortDescriptors
    }
}
