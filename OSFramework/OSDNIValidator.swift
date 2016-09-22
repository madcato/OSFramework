//
//  OSDNIValidator.swift
//  OSFramework
//
//  Created by Daniel Vela on 21/09/2016.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

/**
 Spanish DNI and NIE validator.
 It does not validate NIF.
*/
public class OSDNIValidator: NSObject {

    /**
     Validate the correctness of a DNI number. Only DNI and NIE are validated,
     NIF behaviour is not tested.

     - Parameter dni: DNI to validate

     - Returns: **true** if valid
    */
    public func isValid(dni: String) -> Bool {
        guard dni.characters.count == 9 else { return false }

        var buffer = dni.uppercased()
        let f = buffer.startIndex
        let t = buffer.index(buffer.startIndex, offsetBy: 1)
        buffer = buffer.replacingOccurrences(of: "X", with: "0", options: .caseInsensitive, range: f..<t)
        buffer = buffer.replacingOccurrences(of: "Y", with: "1", options: .caseInsensitive, range: f..<t)
        buffer = buffer.replacingOccurrences(of: "Z", with: "2", options: .caseInsensitive, range: f..<t)

        let number = buffer.substring(with: buffer.startIndex..<(buffer.index(buffer.endIndex, offsetBy: -1)))
        let baseNumber = Int(number)
        let letterMap = "TRWAGMYFPDXBNJZSQVHLCKET"
        let lettersIds = baseNumber! % 23
        let from = letterMap.index(letterMap.startIndex, offsetBy: lettersIds)
        let to = letterMap.index(letterMap.startIndex, offsetBy: lettersIds+1)
        let expectedLetter = letterMap.substring(with: from..<to)
        let from2 = buffer.index(buffer.startIndex, offsetBy: 8)
        let to2 = buffer.index(buffer.startIndex, offsetBy: 9)
        let providedLetter = buffer.substring(with: from2..<to2)
        return expectedLetter == providedLetter
    }
}

