//
//  SessionServiceType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError


public enum SessionServiceEvent<User: UserType> {
    case LogIn(User)
    case LogOut(User)
    case LogInError(SessionServiceError)
}

public enum SessionServiceError: ErrorType {
    case InvalidCredentials(NSError?)
    case NetworkError(NSError)
}

public protocol SessionServiceType {
    
    associatedtype User: UserType
    
    var currentUser: AnyProperty<User?> { get }
    
    var events: Signal<SessionServiceEvent<User>, NoError> { get }
    
    func logIn(email: Email, _ password: String) -> SignalProducer<User, SessionServiceError>
    
}
