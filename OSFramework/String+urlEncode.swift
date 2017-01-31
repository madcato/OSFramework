//
//  String+urlEncode.swift
//  OSFramework
//
//  Created by Daniel Vela on 31/01/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

public extension String
{
    public func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    public func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    
}
