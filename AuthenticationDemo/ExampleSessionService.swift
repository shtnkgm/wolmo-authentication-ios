//
//  ExampleSessionService.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import Authentication
import enum Result.NoError
import ReactiveCocoa
import ReactiveSwift

public struct ExampleUser {
    let email: Email
    let password: String
    let facebookUser: FacebookLoginProviderUser?
    
    init(email: String, password: String) {
        self.email = Email(raw: email)!
        self.password = password
        self.facebookUser = .none
    }

    init(facebookUser: FacebookLoginProviderUser) {
        self.facebookUser = facebookUser
        self.email = facebookUser.email ?? Email(raw: "")!
        self.password = ""
    }

}

public final class ExampleSessionService: SessionServiceType {

    fileprivate let _currentUser: MutableProperty<ExampleUser?> = MutableProperty(.none)
    public let currentUser: Property<ExampleUser?>
    fileprivate let _currentProvider: MutableProperty<String?> = MutableProperty(.none)
    public let currentProviderName: Property<String?>

    private let _email: String
    private let _password: String

    fileprivate let _userDefaults = UserDefaults.standard
    
    init(email: String, password: String) {
        _email = email
        _password = password
        currentUser = Property(_currentUser)
        currentProviderName = Property(_currentProvider)
        loadUserInfo()
        bindPersistance()
    }
    
    public func logIn(withEmail email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        if email.raw == _email {
            if password == _password {
                let user = User(email: email.raw, password: password)
                return logInSuccess(user: user, dispatchTime: dispatchTime)
            } else {
                return logInFailure(dispatchTime: dispatchTime)
            }
        } else {
            return logInFailure(dispatchTime: dispatchTime)
        }
    }
    
    public func logIn(withUser user: LoginProviderUserType) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        switch user {
        case .facebook(let fbUser):
            let exampleUser = ExampleUser(email: fbUser.email?.raw ?? "", password: "")
            return logInSuccess(user: exampleUser, dispatchTime: dispatchTime).on(completed: { [unowned self] in
                self._currentProvider.value = user.providerName
            })
        case .google(let gUser):
            let exampleUser = ExampleUser(email: gUser.email?.raw ?? "", password: "")
            return logInSuccess(user: exampleUser, dispatchTime: dispatchTime).on(completed: { [unowned self] in
                self._currentProvider.value = user.providerName
            })
        case .custom(let name, _):
            print("Signing up a user for service \(name) not supported")
            return logInFailure(dispatchTime: dispatchTime)
        }
    }

    public func signUp(withUsername username: String?, email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        if email.raw == _email {
            let user = ExampleUser(email: email.raw, password: password)
            return signUpSuccess(user: user, dispatchTime: dispatchTime)
        } else {
            return signUpFailure(dispatchTime: dispatchTime)
        }
    }

    public func logOut() {
        _currentUser.value = .none
        _currentProvider.value = .none
    }

}

fileprivate extension ExampleSessionService {

    fileprivate func logInSuccess(user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUser.value = user
        })
    }
    
    fileprivate func logInFailure(dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(error: .invalidLogInCredentials(.none))
            }
        }
    }
    
    fileprivate func signUpSuccess(user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUser.value = user
        })
    }
    
    fileprivate func signUpFailure(dispatchTime: DispatchTime, fromProvider: Bool = false) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                let error: SessionServiceError = fromProvider ? .loginProviderError(name: "Some name",
                        error: SimpleLoginProviderError(localizedMessage: "There was an error login with that provider"))
                                                              : .invalidSignUpCredentials(.none)
                observer.send(error: error)
            }
        }
    }
    
}

fileprivate extension ExampleSessionService {

    fileprivate func bindPersistance() {
        currentUser.producer.startWithValues { [unowned self] in
            switch $0 {
            case .some(let user): self.save(user: user)
            case .none: self.clearUser()
            }
        }
        currentProviderName.producer.startWithValues { [unowned self] in
            switch $0 {
            case .some(let name): self.save(providerName: name)
            case .none: self.clearProviderName()
            }
        }
    }

    fileprivate func loadUserInfo() {
        if let user = getUser() {
            _currentUser.value = user
        }
        if let providerName = getProviderName() {
            _currentProvider.value = providerName
        }
    }

    private static let UserKey = "AuthExample.User"
    private static let ProviderKey = "AuthExample.Provider"

    private func save(user: ExampleUser) {
        // Here you could persist your token or something.
        // Preferably, through a PersistanceService.
        let dict = ["Email": user.email.raw, "Password": user.password]
        _userDefaults.set(dict, forKey: ExampleSessionService.UserKey)
    }

    private func getUser() -> ExampleUser? {
        let info = _userDefaults.dictionary(forKey: ExampleSessionService.UserKey) as? [String: String]
        return info.map { ExampleUser(email: $0["Email"]!, password: $0["Password"]!) }
    }

    private func clearUser() {
        // Here you could clear the token from persistance.
        _userDefaults.removeObject(forKey: ExampleSessionService.UserKey)
    }

    private func save(providerName: String) {
        // Here you could persist in the same place the provider's name
        _userDefaults.set(providerName, forKey: ExampleSessionService.ProviderKey)
    }

    private func getProviderName() -> String? {
        return _userDefaults.string(forKey: ExampleSessionService.ProviderKey)
    }

    private func clearProviderName() {
        // Here you could clear the provider's name from persistance.
        _userDefaults.removeObject(forKey: ExampleSessionService.ProviderKey)
    }

}
