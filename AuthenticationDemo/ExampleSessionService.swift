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
    private let _registeredAlready: Bool
    
    init(email: String, password: String) {
        _email = email
        _password = password
        _registeredAlready = false
        currentUser = Property(_currentUser)
        currentProviderName = Property(_currentProvider)
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
            return signUpSuccess(user: exampleUser, dispatchTime: dispatchTime).on(completed: { [unowned self] in
                self._currentProvider.value = user.providerName
            })
        case .custom(let name, _):
            print("Signing up a user for service \(name) not supported")
            return signUpFailure(dispatchTime: dispatchTime, fromProvider: true)
        }
    }

    public func signUp(withUsername username: String?, email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        if email.raw == _email {
            if _registeredAlready {
                return signUpFailure(dispatchTime: dispatchTime)
            } else {
                let user = ExampleUser(email: email.raw, password: password)
                return signUpSuccess(user: user, dispatchTime: dispatchTime)
            }
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

    private func save(user: ExampleUser) {
        // Here you could persist your token or something.
        // Preferably, through a PersistanceService.
    }

    private func clearUser() {
        // Here you could clear the token from persistance.
    }

    private func save(providerName: String) {
        // Here you could persist in the same place the provider's name
    }

    private func clearProviderName() {
        // Here you could clear the provider's name from persistance.
    }

}
