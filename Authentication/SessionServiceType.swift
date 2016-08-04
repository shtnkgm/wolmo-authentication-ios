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


/**
     Represents any possible error that may happen
     in the session service through the authentication
     process.
*/
public enum SessionServiceError: ErrorType {
    case InvalidLogInCredentials(NSError?)
    case InvalidSignUpCredentials(NSError?)
    case NetworkError(NSError)
}

/**
    Protocol that any SessionService must conform
    to be able to handle the user session within
    this framework.
 */
public protocol SessionServiceType {
    
    associatedtype User
    
    /**
         The current user logged in in the app.
         
         This will be consulted by the framework to check
         if a user is already logged in or if the
         authentication process should be triggered.
    */
    var currentUser: AnyProperty<User?> { get }
    
    /**
        This method takes care of validating and logging in.
     
        - Returns: A SignalProducer that can send the User logged in
        or the SessionServiceError if not.
        If the credentials are valid, the SignalProducer returned
        must take care of:
            sending the user to the observers and
            updating the currentUser property.
        If the credentials aren't valid, the SignalProducer returned
        must take care of:
            sending the error to the observer.
    */
    func logIn(email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
    /**
         This method takes care of validating and signing up.
         
         - Returns: A SignalProducer that can send the User logged in
         or the SessionServiceError if not.
         If the credentials are valid, the SignalProducer returned
         must take care of:
             sending the user to the observers and
             updating the currentUser property.
         If the credentials aren't valid, the SignalProducer returned
         must take care of:
             sending the error to the observer.
    */
    func signUp(username: String?, email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
}

public extension SessionServiceError {
    
    /**
         The message from an error service is composed by
            a localized message relate to the error type and
            the description of the NSError tat accompanies it, if there is any.
    */
    internal var message: String {
        switch self {
        case .InvalidSignUpCredentials(let error):
            return "signup-error.invalid-credentials.message".frameworkLocalized + ". " + (error?.localizedDescription ?? "")
        case .InvalidLogInCredentials(let error):
            return "login-error.invalid-credentials.message".frameworkLocalized + ". " + (error?.localizedDescription ?? "")
        case .NetworkError(let error):
            return "network-error.message".frameworkLocalized + ". " + error.localizedDescription
        }
    }
    
}
