//
//  HttpAPI.swift
//  OSFramework
//
//  Created by Daniel Vela on 13/06/2017.
//  Copyright © 2017 Daniel Vela. All rights reserved.
//

import Foundation

class HttpAPI {
    var request: HttpRequest

    required init(_ request: HttpRequest) {
        self.request = request
    }
}
