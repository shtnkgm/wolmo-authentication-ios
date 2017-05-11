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
    
    init(email: String, password: String) {
        self.email = Email(raw: email)!
        self.password = password
    }
}

public final class ExampleSessionService: SessionServiceType {
    
    fileprivate let (_currentUser, _currentUserObserver) = Signal<ExampleUser?, NoError>.pipe()
    public let currentUser: Property<ExampleUser?>
    
    private let _email: String
    private let _password: String
    private let _registeredAlready: Bool
    fileprivate var _isFacebook: Bool
    
    init(email: String, password: String) {
        _email = email
        _password = password
        _registeredAlready = false
        _isFacebook = false
        currentUser = Property(initial: Optional.none, then: _currentUser)
    }
    
    deinit {
        _currentUserObserver.sendCompleted()
    }
    
    public func logIn(withEmail email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        if email.raw == _email {
            if password == _password {
                let user = User(email: email.raw, password: password)
                self._isFacebook = false
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
            self._isFacebook = true
            return signUpSuccess(user: exampleUser, dispatchTime: dispatchTime)
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
                self._isFacebook = false
                return signUpSuccess(user: user, dispatchTime: dispatchTime)
            }
        } else {
            return signUpFailure(dispatchTime: dispatchTime)
        }
    }

    public func logOut() {
        _currentUserObserver.send(value: .none)
        if _isFacebook {
            (UIApplication.shared.delegate as? AppDelegate)?.facebookProvider.logOut().start()
        }
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
            self._currentUserObserver.send(value: user)
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
        return SignalProducer<ExampleUser, SessionServiceError> { [unowned self] observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUserObserver.send(value: user)
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
