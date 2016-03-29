//
//  ExampleRegistrationService.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import Authentication
import ReactiveCocoa

final class ExampleRegistrationService: RegistrationServiceType {
    
    private let _email: String
    private let _registeredAlready: Bool
    
    init(email: String) {
        _email = email
        _registeredAlready = false
    }
    
    func signUp(name: String, _ email: Email, _ password: String) -> SignalProducer<ExampleUser, RegistrationServiceError> {
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC))
        if email.raw == _email {
            if _registeredAlready {
                return failureSignalProducer(dispatchTime)
            } else {
                let user = ExampleUser(email: email.raw, password: password)
                return successSignalProducer(user, dispatchTime: dispatchTime)
            }
        } else {
            return failureSignalProducer(dispatchTime)
        }
    }
    
    private func successSignalProducer(user: ExampleUser, dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, RegistrationServiceError> {
        return SignalProducer<ExampleUser, RegistrationServiceError> { observer, disposable in
                dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
            }
    }
    
    private func failureSignalProducer(dispatchTime: dispatch_time_t) -> SignalProducer<ExampleUser, RegistrationServiceError> {
        return SignalProducer<ExampleUser, RegistrationServiceError> { observer, disposable in
                dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                    observer.sendFailed(.InvalidCredentials(.None))
                }
            }
    }

    
}
