//
//  Observable.swift
//  TestObservable
//
//  Created by Daniel Vela on 13/03/2018.
//  Copyright © 2018 veladan. All rights reserved.
//
//
// https://colindrake.me/post/an-observable-pattern-implementation-in-swift/
//

typealias ObserverBlock<T> = (_ newValue: T, _ oldValue: T) -> Void

protocol ObservableProtocol {
    associatedtype AType
    var value: AType { get set }
    func subscribe(_ observer: AnyObject, block: @escaping ObserverBlock<AType>)
    func unsubscribe(_ observer: AnyObject)
}

/*!
 Observable class pattern
 Sample implementation:
     class ConcreteImplementation2 {
         func run() {
             let initial = 3
             var v = initial
             let obs = Observable(initial)
             obs.subscribe(self) { (newValue, oldValue) in
                 print("Object updated!")
                 v = newValue
             }
            obs.onChange { (newValue, oldValue) in
                print("Object changed!")
            }
            obs.value = 4  // Trigger update.
            print(v)       // 4!
         }
     }
 */
public final class Observable<T>: ObservableProtocol {
    typealias ObserversEntry = (observer: AnyObject, block: ObserverBlock<T>)
    var value: T {
        didSet {
            observers.forEach { (entry) in
                let (_, block) = entry
                block(value, oldValue)
            }
        }
    }
    var observers: [ObserversEntry] = []

    init(_ value: T) {
        self.value = value
    }

    /// If you use this method, object can't be unsubscribed
    func onChange(block: @escaping ObserverBlock<T>) {
        subscribe(Observable<Int>(0), block: block)
    }

    func subscribe(_ observer: AnyObject, block: @escaping ObserverBlock<T>) {
        let entry: ObserversEntry = (observer: observer, block: block)
        observers.append(entry)
    }

    func unsubscribe(_ observer: AnyObject) {
        observers = observers.filter { entry in
            let (owner, _) = entry
            return owner !== observer
        }
    }

    static func << <T>(_ this: Observable<T>, _ value: T) {
        this.value = value
    }
}
