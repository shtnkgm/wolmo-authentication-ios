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
    case SignUp(User)
    case LogInError(SessionServiceError)
    case SignUpError(SessionServiceError)
}

public enum SessionServiceError: ErrorType {
    case InvalidLogInCredentials(NSError?)
    case InvalidSignUpCredentials(NSError?)
    case NetworkError(NSError)
}

public protocol SessionServiceType {
    
    associatedtype User: UserType
    
    var currentUser: AnyProperty<User?> { get }
    
    var events: Signal<SessionServiceEvent<User>, NoError> { get }
    
    /**
        This method takes care of validating and logging in.
     
        - Returns: A SignalProducer that can send the User logged in
        or the SessionServiceError if not.
        If the credentials are valid, the SignalProducer returned
        must take care of:
            sending the user to the observers
            sending the login event through the events signal and
            updating the currentUser property.
        If the credentials aren't valid, the SignalProducer returned
        must take care of:
            sending the error to the observer and
            sending the login error event through the events signal.
    */
    func logIn(email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
    /**
         This method takes care of validating and signing up.
         
         - Returns: A SignalProducer that can send the User logged in
         or the SessionServiceError if not.
         If the credentials are valid, the SignalProducer returned
         must take care of:
             sending the user to the observers
             sending the sign up and the login event through the events signal and
             updating the currentUser property.
         If the credentials aren't valid, the SignalProducer returned
         must take care of:
             sending the error to the observer and
             sending the singup error event through the events signal.
    */
    func signUp(name: String, email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
}

public extension SessionServiceError {
    var message: String {
        switch self {
        case .InvalidSignUpCredentials(let error):
            return "signup-error.invalid-credentials.message".localized + (error?.localizedDescription ?? "")
        case .InvalidLogInCredentials(let error):
            return "login-error.invalid-credentials.message".localized + (error?.localizedDescription ?? "")
        case .NetworkError(let error):
            return "login-error.network-error.message".localized + error.localizedDescription
        }
    }
}
