//
//  GenericModel.swift
//  OSFramework
//
//  Created by Daniel Vela Angulo on 31/10/2018.
//  Copyright © 2018 Daniel Vela. All rights reserved.
//

enum ModelError: Error {
    case parameterNotExists(parameter: String)
    case invalidTypeAssignment(parameter: String)
}

protocol PropertyAdapter {
    func adapt<T>(value: T) -> String
}

class GenericModel {
}

class NameProperyAdapter: PropertyAdapter {
    func adapt<T>(value: T) -> String {
        return "Name: \(value)"
    }
}

class AgeProperyAdapter: PropertyAdapter {
    func adapt<T>(value: T) -> String {
        return "Age: \(value)"
    }
}

class ConcreteObservableModel: GenericModel {
    fileprivate var obsName: Observable<String> = Observable<String>("")
    fileprivate var obsAge: Observable<Int> = Observable<Int>(0)
}

class ConcreteModel: ConcreteObservableModel, Decodable {
    var name: String {
        get {
            return super.obsName.value
        }
        set {
            super.obsName.value = newValue
        }
    }
    var age: Int {
        get {
            return super.obsAge.value
        }
        set {
        super.obsAge.value = newValue
        }
    }

    // guard let <# property name #> = dictionary["<# property name #>"] as? <# property type #> else {
    //     throw ModelError.parameterNotExists(parameter: "<# property name #>")
    // }
    // self.<# property name #> = <# property name #>
    init(with dictionary: [AnyHashable: Any?] ) throws {
        super.init()
        // TODO: use Codable protocol to create generic constructors
        guard let name = dictionary["name"] as? String else {
            throw ModelError.parameterNotExists(parameter: "name")
        }
        self.name = name
        guard let age = dictionary["age"] as? Int else {
            throw ModelError.parameterNotExists(parameter: "age")
        }
        self.age = age
    }

    override init() {

    }
}

class ConcreteAdaptableModel: CustomDebugStringConvertible {
    var model: ConcreteModel
    var adapters: [String: PropertyAdapter] = [:]

    init(model: ConcreteModel) {
        self.model = model
    }

    var nameStr: String {
        get {
            if let adapter = adapters["name"] {
                return adapter.adapt(value: model.name)
            }
            return model.name
        }
        set {
            model.name = newValue
        }
    }

    var ageStr: String {
        get {
            if let adapter = adapters["age"] {
                return adapter.adapt(value: model.age)
            }
            return "\(model.age)"
        }
        set {
            model.age = Int(newValue) ?? 0
        }
    }

    // Protocol CustomDebugStringConvertible
    var debugDescription: String {
        return "(\(nameStr), \(ageStr))"
    }
}

public func runSample1() throws {
    let model = try ConcreteModel(with: ["name": "Dani", "age": 32])
    let adapted = ConcreteAdaptableModel(model: model)
    let pro1 = NameProperyAdapter()
    let pro2 = AgeProperyAdapter()
    adapted.adapters["name"] = pro1
    adapted.adapters["age"] = pro2
    print(adapted)
}

public func runSample2() {
    let model = ConcreteModel()
    let adapted = ConcreteAdaptableModel(model: model)
    adapted.nameStr = "Pepe"
    adapted.ageStr = "34"
    print(String(describing: adapted))
}
