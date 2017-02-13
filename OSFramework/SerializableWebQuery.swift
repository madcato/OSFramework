//
//  SerializableWebQuery.swift
//  TestPersistWebObject
//
//  Created by Daniel Vela on 13/02/17.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation


class SerializableWebQuery: NSObject, NSCoding {
    var url: String
    var parameters: [String : Any]
    var sender: EoloSenderInteractor?
    
    init(url: String, parameters: [String: Any], sender: EoloSenderInteractor) {
        self.url = url
        self.parameters = parameters
        self.sender = sender
    }
    
    func start(_ onOK: @escaping () -> (), onError: @escaping () -> () ) {
        sender?.postJSON(url: self.url, parameters: self.parameters, onOK: { (result) in
            // Revome this object in Serrializable data
            onOK()
        }) { (result, message) in
            // Keep this object in seriliable data
            onError()
        }
    }
    
    func stop() {
        sender?.cancel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as! String
        self.parameters = aDecoder.decodeObject(forKey: "parameters") as! [String: Any]
    }

    func encode(with aCoder: NSCoder) {
        self.stop()
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.parameters, forKey: "parameters")
    }
}
