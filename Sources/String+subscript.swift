//
//  String+subscript.swift
//  happic-ios
//
//  Created by Daniel Vela on 29/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation

extension String {
    var length: Int {
        return self.characters.count
    }

    subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }

    subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return self[range]
    }

    func makeRange(_ integerRange: Range<Int>) -> Range<String.CharacterView.Index> {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        return start..<end
    }
}
