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
    
    init(email: String, password: String) {
        _email = email
        _password = password
        currentUser = AnyProperty(initialValue: Optional.None, signal: _currentUser.map { $0 })
        (events, _eventsObserver) = Signal<SessionServiceEvent<ExampleUser>, NoError>.pipe()
    }
    
    public func logIn(email: Email, _ password: String) -> SignalProducer<ExampleUser, SessionServiceError> {
        sleep(5)
        if email.raw == _email {
            if password == _password {
                let user = User(email: email.raw, password: password)
                return SignalProducer(value: user).on(completed: { [unowned self] in
                    self._eventsObserver.sendNext(.LogIn(user))
                    self._currentUserObserver.sendNext(user)
                })
            } else {
                return SignalProducer(error: SessionServiceError.InvalidCredentials(.None)).on(failed: { [unowned self] _ in
                    self._eventsObserver.sendNext(.LogInError(.InvalidCredentials(.None)))
                })
                
            }
        } else {
            return SignalProducer(error: SessionServiceError.InvalidCredentials(.None)).on(failed: { [unowned self] _ in
                self._eventsObserver.sendNext(.LogInError(.InvalidCredentials(.None)))
                })
            
        }
    }
    
}
