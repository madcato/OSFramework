//
//  EoloSender.swift
//  OSFramework
//
//  Created by Daniel Vela on 13/02/17.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import Foundation

public protocol EoloSenderInteractor {
    func postJSON(url: String,
                  parameters: [String: Any],
                  onOK: @escaping (Any?) -> Void,
                  onError: @escaping (Int, String) -> Void)
    func cancel()
}

public class EoloSender {

    var fileName = "WebQueriesData"

    var data: [SerializableWebQuery] = []

    var running = false

    var senderObject: EoloSenderInteractor

    public init(senderObject: EoloSenderInteractor) {
        self.senderObject = senderObject
    }

    public func append(_ url: String, parameters: [String: Any]) {
        self.data.append(SerializableWebQuery(url: url,
                                              parameters: parameters,
                                              sender: self.senderObject))
        startContinue()
    }

    // Call this method from applicationDidBecomeActive
    public func appBecomeActive() {
        let restoredObjects = Serializator().restoreObject(fileName: fileName)
        if let restoredObjects = restoredObjects {
            self.data = restoredObjects as? [SerializableWebQuery] ?? []
            for object in self.data {
                object.sender = self.senderObject
            }
        }
        startContinue()
    }

    // Call this method from applicationWillResignActive
    public func appBecomeInactive() {
        Serializator().saveObject(object: self.data as AnyObject, fileName: fileName)
    }

    func startContinue() {
        if running == false {
            running = true
        } else {
            return
        }
        sendAQuery()
    }

    static let initialSecondsToWaitOnError: Double = 15.0
    var secondsToWaitOnError = {
        initialSecondsToWaitOnError
    }()

    func sendAQuery() {
        DispatchQueue.global(qos: .background).async {
            if self.data.count > 0 {
                let webQuery = self.data.removeFirst()
                webQuery.start({
                        // Nothing. The query was ok
                        // Continue with next one
                        self.sendAQuery()
                        self.secondsToWaitOnError = EoloSender.initialSecondsToWaitOnError
//                    print("Pairing registered", webQuery.parameters)
                    }, onError: {
                        // On error the query must be restored on the queue
                        DispatchQueue.global(qos: .background).async {
                            self.data.append(webQuery)
                            // and wait some seconds
                            Thread.sleep(forTimeInterval: self.secondsToWaitOnError)
                            self.sendAQuery()
                        }
//                    print("Pairing error", webQuery.parameters)
                })
            } else {
                self.running = false
            }
        }
    }
}
