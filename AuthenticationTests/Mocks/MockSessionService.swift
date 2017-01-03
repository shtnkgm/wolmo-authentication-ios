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
import ReactiveSwift
import enum Result.NoError

final class MockSessionService: SessionServiceType {
    
    let currentUser: Property<MyUser?>
    
    let logInCalled: Signal<Bool, NoError>
    let signUpCalled: Signal<Bool, NoError>
    
    fileprivate let _logInCalledObserver: Observer<Bool, NoError>
    fileprivate let _signUpCalledObserver: Observer<Bool, NoError>
    
    
    init() {
        currentUser = Property(initial: Optional.none, then: SignalProducer.never)
        (logInCalled, _logInCalledObserver) = Signal<Bool, NoError>.pipe()
        (signUpCalled, _signUpCalledObserver) = Signal<Bool, NoError>.pipe()
    }
    
    deinit {
        _logInCalledObserver.sendCompleted()
        _signUpCalledObserver.sendCompleted()
    }
    
    func logIn(_ email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        return SignalProducer.empty.on(completed: { [unowned self] in self._logInCalledObserver.send(value: true) })
    }
    
    func signUp(_ name: String?, email: Email, password: String) -> SignalProducer<MyUser, SessionServiceError> {
        return SignalProducer.empty.on(completed: { [unowned self] in self._signUpCalledObserver.send(value: true) })
    }
    
}
