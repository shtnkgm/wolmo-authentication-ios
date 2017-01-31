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
    
    private let (_currentUser, _currentUserObserver) = Signal<ExampleUser, NoError>.pipe()
    public let currentUser: Property<ExampleUser?>
    
    private let _email: String
    private let _password: String
    private let _registeredAlready: Bool
    
    init(email: String, password: String) {
        _email = email
        _password = password
        _registeredAlready = false
        currentUser = Property(initial: Optional.none, then: _currentUser.map { $0 })
    }
    
    deinit {
        _currentUserObserver.sendCompleted()
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
    
    public func logIn(withUserType userType: LoginProviderUserType) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + 2.0
        switch userType {
        case .facebook(let fbUser):
            let exampleUser = ExampleUser(email: fbUser.email?.raw ?? "", password: "")
            return signUpSuccess(user: exampleUser, dispatchTime: dispatchTime)
        case .custom(let name, _):
            print("Signing up a user for service \(name) not supported")
            return signUpFailure(dispatchTime: dispatchTime)
        }
    }

    private func logInSuccess(user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUserObserver.send(value: user)
        })
    }
    
    private func logInFailure(dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(error: .invalidLogInCredentials(.none))
            }
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
    
    private func signUpSuccess(user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUserObserver.send(value: user)
        })
    }
    
    private func signUpFailure(dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(error: .invalidSignUpCredentials(.none))
            }
        }
    }
    
}
