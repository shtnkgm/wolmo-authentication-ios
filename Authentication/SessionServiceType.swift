//
//  SessionServiceType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

/**
     Represents any possible error that may happen
     in the session service through the authentication
     process.
*/
public enum SessionServiceError: Error {
    case invalidLogInCredentials(NSError?)
    case invalidSignUpCredentials(NSError?)
    case networkError(NSError)
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
    var currentUser: Property<User?> { get }
    
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
    func logIn(withEmail email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
    /**
     This method takes care of logging in (or signing up, if not
     already registered) the passed user.
     It's meant to be used alongisde login providers, like
     the FacebookLoginProvider.
     
     Be aware that in this method you must take care of creating
     a user of the `User` type from the userType passed as argument.
     
     - Returns: A SignalProducer that can send the User logged in
     or the SessionServiceError if not.
     If the creation of the user is successful, the SignalProducer
     returned must take care of:
        sending the user to the observers and
        updating the currentUser property.
     If not, the SignalProducer returned
     must take care of:
        sending the error to the observer.
     */
    func logIn(withUserType userType: LoginProviderUserType) -> SignalProducer<User, SessionServiceError>
    
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
    func signUp(withUsername username: String?, email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
}

public extension SessionServiceError {
    
    /**
         The message from an error service is composed by
            a localized message relate to the error type and
            the description of the NSError tat accompanies it, if there is any.
    */
    internal var message: String {
        switch self {
        case .invalidSignUpCredentials(let error):
            return "signup-error.invalid-credentials.message".frameworkLocalized + ". " + (error?.localizedDescription ?? "")
        case .invalidLogInCredentials(let error):
            return "login-error.invalid-credentials.message".frameworkLocalized + ". " + (error?.localizedDescription ?? "")
        case .networkError(let error):
            return "network-error.message".frameworkLocalized + ". " + error.localizedDescription
        }
    }
    
}
