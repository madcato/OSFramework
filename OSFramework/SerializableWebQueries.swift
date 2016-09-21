//
//  SerializableWebQueries.swift
//  happic-ios
//
//  Created by Daniel Vela on 04/07/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation

class SerializableWebQueries {
    
    var fileName = "WebQueriesData"
    
    var data: [SerializableWebQuery] = []
    
    var running = false
    
    func append(url: String, parameters: [NSObject:AnyObject]) {
        self.data.append(SerializableWebQuery(url: url))
        
        startContinue()
    }
    
    func appBecomeActive() {
        let restoredObjects = Serializator().restoreObject(fileName: fileName)
        if let restoredObjects = restoredObjects {
            self.data = restoredObjects as! [SerializableWebQuery]
        }
        startContinue()
    }
    
    func appBecomeInactive() {
        Serializator().saveObject(object: self.data, fileName: fileName)
    }
    
    func startContinue() {
        if running == false {
            running = true
        }else {
            return
        }
        
        sendAQuery()
        
    }
    
    static let initialSecondsToWaitOnError: Double = 5.0
    var secondsToWaitOnError = {
        initialSecondsToWaitOnError
    }()
    
    func sendAQuery() {
        DispatchQueue.global(qos: .background).async {
            if self.data.count > 0 {
                let webQuery = self.data.removeFirst()
                
                webQuery.start(onOk: {
                        // Nothing. The query was ok
                        // Continue with next one
                        self.sendAQuery()
                        self.secondsToWaitOnError = SerializableWebQueries.initialSecondsToWaitOnError
                    }(), onError: {
                        // On error the query must be restored on the queue
                        DispatchQueue.global(qos: .background).async {
                            self.data.append(webQuery)
                            // and wait some seconds
                            Thread.sleep(forTimeInterval: self.secondsToWaitOnError)
                            self.secondsToWaitOnError *= 2
                            self.sendAQuery()
                        }
                }())
            } else {
                self.running = false
            }
        }
    }
}
