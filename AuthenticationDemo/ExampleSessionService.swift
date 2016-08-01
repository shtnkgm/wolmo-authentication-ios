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

public struct ExampleUser: UserType {
    let email: Email
    let password: String
    
    init(email: String, password: String) {
        self.email = Email(raw: email)!
        self.password = password
    }
}


public final class ExampleSessionService: SessionServiceType {
    
    private let (_currentUser, _currentUserObserver) = Signal<ExampleUser, NoError>.pipe()
    public let currentUser: AnyProperty<ExampleUser?>
    
    public let events: Signal<SessionServiceEvent<ExampleUser>, NoError>
    private let _eventsObserver: Signal<SessionServiceEvent<ExampleUser>, NoError>.Observer
    
    private let _email: String
    private let _password: String
    private let _registeredAlready: Bool
    
    init(email: String, password: String) {
        _email = email
        _password = password
        _registeredAlready = false
        currentUser = AnyProperty(initialValue: Optional.None, signal: _currentUser.map { $0 })
        (events, _eventsObserver) = Signal<SessionServiceEvent<ExampleUser>, NoError>.pipe()
    }
    
    deinit {
        _currentUserObserver.sendCompleted()
        _eventsObserver.sendCompleted()
    }
    
    public func logIn(email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC))
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
    
    private func logInSuccess(user: ExampleUser, dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, disposable in
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                observer.sendNext(user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._eventsObserver.sendNext(.LogIn(user))
            self._currentUserObserver.sendNext(user)
        })
    }
    
    private func logInFailure(dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, disposable in
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                observer.sendFailed(.InvalidLogInCredentials(.None))
            }
        }.on(failed: { [unowned self] _ in
            self._eventsObserver.sendNext(.LogInError(.InvalidLogInCredentials(.None)))
        })
    }
    
    public func signUp(username: String?, email: Email, password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC))
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
    
    private func signUpSuccess(user: ExampleUser, dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, disposable in
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                observer.sendNext(user)
                observer.sendCompleted()
            }
        }.on(completed: { [unowned self] in
            self._eventsObserver.sendNext(.SignUp(user))
            self._currentUserObserver.sendNext(user)
        })
    }
    
    private func signUpFailure(dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, SessionServiceError> {
        return SignalProducer<ExampleUser, SessionServiceError> { observer, disposable in
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                observer.sendFailed(.InvalidSignUpCredentials(.None))
            }
        }
    }
    
}
