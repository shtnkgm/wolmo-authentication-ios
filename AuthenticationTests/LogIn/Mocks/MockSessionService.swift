//
//  MockSessionService.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/14/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import Authentication

import ReactiveCocoa
import enum Result.NoError

final class MockSessionService: SessionServiceType {
    
    private let _possibleUser: MyUser
    private let (_currentUser, _currentUserObserver) = Signal<MyUser, NoError>.pipe()
    
    let currentUser: AnyProperty<MyUser?>
    
    let events: Signal<SessionServiceEvent<MyUser>, NoError>
    private let _eventsObserver: Signal<SessionServiceEvent<MyUser>, NoError>.Observer
    
    init(email: Email, password: String, name: String) {
        _possibleUser = User(email: email, password: password, name: name)
        currentUser = AnyProperty(initialValue: Optional.None, signal: _currentUser.map { $0 })
        (events, _eventsObserver) = Signal<SessionServiceEvent<User>, NoError>.pipe()
    }
    
    func logIn(email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        if email == self._possibleUser.email && password == self._possibleUser.password {
            return SignalProducer(value: self._possibleUser).on(completed: { [unowned self] in
                self._eventsObserver.sendNext(.LogIn(self._possibleUser))
                self._currentUserObserver.sendNext(self._possibleUser)
            })
        } else {
            return SignalProducer(error: SessionServiceError.InvalidLogInCredentials(.None)).on(failed: { [unowned self] _ in
                self._eventsObserver.sendNext(.LogInError(.InvalidLogInCredentials(.None)))
            })
            
        }
    }
    
    func signUp(name: String?, email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        return SignalProducer.empty
    }
    
}