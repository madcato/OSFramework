//
//  OSLoginViewModel.swift
//  Presencheck
//
//  Created by Daniel Vela on 25/06/17.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

public enum LoginState {
    case `init`
    case progressing
    case ok
    case error(Int, String)
}

public protocol OSLoginInteractor {
    func doLogin(_ email: String, password: String, onOK: @escaping () -> (), onError: @escaping (Int, String) -> ());
}

public protocol OSSavedLoginInteractor {
    var login: String? { get }
    var password: String? { get }
    func save(_ login: String?, password: String?);
    func clearSaved();
}

public protocol OSLoginViewModelProtocol {
    var state: LoginState { get }
    var stateDidChange: ((OSLoginViewModelProtocol) -> ())? { get set }
    init(loginInteractor: OSLoginInteractor, savedLoginInteractor: OSSavedLoginInteractor)
    func doLogin(_ email: String, password: String, remember: Bool)
    
    var login: String? { get }
    var loginDidChange: ((OSLoginViewModelProtocol) -> ())? { get set }
    
    var password: String? { get }
    var passwordDidChange: ((OSLoginViewModelProtocol) -> ())? { get set }
    
    var remember: Bool { get }
    var rememberDidChange: ((OSLoginViewModelProtocol) -> ())? { get set }
}

public class OSLoginViewModel: OSLoginViewModelProtocol {
    public var state: LoginState {
        didSet {
            self.stateDidChange?(self)
        }
    }
    public var stateDidChange: ((OSLoginViewModelProtocol) -> ())?
    
    public var login: String? {
        didSet {
            self.loginDidChange?(self)
        }
    }
    public var loginDidChange: ((OSLoginViewModelProtocol) -> ())?
    
    public var password: String? {
        didSet {
            self.passwordDidChange?(self)
        }
    }
    public var passwordDidChange: ((OSLoginViewModelProtocol) -> ())?
    
    public var remember: Bool {
        didSet {
            self.rememberDidChange?(self)
        }
    }
    public var rememberDidChange: ((OSLoginViewModelProtocol) -> ())?
    
    
    var loginInteractor: OSLoginInteractor
    var savedLogin: OSSavedLoginInteractor
    
    public required init(loginInteractor: OSLoginInteractor, savedLoginInteractor: OSSavedLoginInteractor) {
        state = .init
        self.loginInteractor = loginInteractor
        self.savedLogin = savedLoginInteractor
        if let login = self.savedLogin.login {
            self.login = login
            if let password = self.savedLogin.password {
                self.password = password
            }
            self.remember = true
        } else {
            self.remember = false
        }
    }

    public func doLogin(_ email: String, password: String, remember: Bool) {
        if remember {
            save(email, password: password)
        } else {
            clearSaved()
        }
        state = .progressing
        loginInteractor.doLogin(email, password: password, onOK: { [unowned self] in
                self.state = .ok
        }) { [unowned self] (code: Int, message: String) in
                self.state = .error(code, message)
        }
    }
    
    public func save(_ email: String, password: String) {
        self.savedLogin.save(email, password: password)
    }
    
    public func clearSaved() {
        self.savedLogin.clearSaved()
    }
}
