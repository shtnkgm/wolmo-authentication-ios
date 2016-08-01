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
    
    let currentUser: AnyProperty<MyUser?>
    let events: Signal<SessionServiceEvent<MyUser>, NoError>
    
    let logInCalled: Signal<Bool, NoError>
    let signUpCalled: Signal<Bool, NoError>
    
    private let _eventsObserver: Signal<SessionServiceEvent<MyUser>, NoError>.Observer
    private let _logInCalledObserver: Observer<Bool, NoError>
    private let _signUpCalledObserver: Observer<Bool, NoError>
    
    
    init() {
        currentUser = AnyProperty(initialValue: Optional.None, producer: SignalProducer.never)
        (events, _eventsObserver) = Signal<SessionServiceEvent<MyUser>, NoError>.pipe()
        (logInCalled, _logInCalledObserver) = Signal<Bool, NoError>.pipe()
        (signUpCalled, _signUpCalledObserver) = Signal<Bool, NoError>.pipe()
    }
    
    deinit {
        _eventsObserver.sendCompleted()
        _logInCalledObserver.sendCompleted()
        _signUpCalledObserver.sendCompleted()
    }
    
    func logIn(email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        return SignalProducer.empty.on(completed: { [unowned self] in self._logInCalledObserver.sendNext(true) })
    }
    
    func signUp(name: String?, email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        return SignalProducer.empty.on(completed: { [unowned self] in self._signUpCalledObserver.sendNext(true) })
    }
    
}