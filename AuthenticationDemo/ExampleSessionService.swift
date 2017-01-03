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
    
    fileprivate let (_currentUser, _currentUserObserver) = Signal<ExampleUser, NoError>.pipe()
    public let currentUser: Property<ExampleUser?>
    
    fileprivate let _email: String
    fileprivate let _password: String
    fileprivate let _registeredAlready: Bool
    
    init(email: String, password: String) {
        _email = email
        _password = password
        _registeredAlready = false
        currentUser = Property(initial: Optional.none, then: _currentUser.map { $0 })
    }
    
    deinit {
        _currentUserObserver.sendCompleted()
    }
    
    public func logIn(_ email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        if email.raw == _email {
            if password == _password {
                let user = User(email: email.raw, password: password)
                return logInSuccess(user, dispatchTime: dispatchTime)
            } else {
                return logInFailure(dispatchTime)
            }
        } else {
            return logInFailure(dispatchTime)
        }
    }
    
    fileprivate func logInSuccess(_ user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUserObserver.send(value: user)
        })
    }
    
    fileprivate func logInFailure(_ dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(error: .invalidLogInCredentials(.none))
            }
        }
    }
    
    public func signUp(_ username: String?, email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        if email.raw == _email {
            if _registeredAlready {
                return signUpFailure(dispatchTime)
            } else {
                let user = ExampleUser(email: email.raw, password: password)
                return signUpSuccess(user, dispatchTime: dispatchTime)
            }
        } else {
            return signUpFailure(dispatchTime)
        }
    }
    
    fileprivate func signUpSuccess(_ user: ExampleUser, dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(value: user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._currentUserObserver.send(value: user)
        })
    }
    
    fileprivate func signUpFailure(_ dispatchTime: DispatchTime) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, _ in
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                observer.send(error: .invalidSignUpCredentials(.none))
            }
        }
    }
    
}
