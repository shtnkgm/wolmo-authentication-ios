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
 
     It includes and wraps up any error that may arise
     from the login providers
*/
public enum SessionServiceError: Error {
    case invalidLogInCredentials(NSError?)
    case invalidSignUpCredentials(NSError?)
    case networkError(NSError)
    case loginProviderError(name: String, error: LoginProviderError)
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
         The name of login provider from which we obtained
         the current user, if there is one.

         This will be consulted by the framework in order to be
         able to provide you the LoginProvider from which to log out.
         This is thought so that it serves after reopening the app:
            you create the provider again and are able to make the
            logout (the login provider shoud be made so that you can
            log out a user even after recreating the provider, like
            facebook does).
     */
    var currentProviderName: Property<String?> { get }

    /**
        This method takes care of validating and logging in.
     
        - Returns: A SignalProducer that can send the User logged in
        or the SessionServiceError if not.
        If the credentials are valid, the SignalProducer returned
        must take care of:
            sending the user to the observers and
            updating the currentUser and currentProviderName properties.
        If the credentials aren't valid, the SignalProducer returned
        must take care of:
            sending the error to the observer.
    */
    func logIn(withEmail email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
    /**
     This method takes care of logging in (or signing up, if not
     already registered) the passed user.
     It's meant to be used alongside login providers, like
     the FacebookLoginProvider.
     
     Be aware that in this method you must take care of creating
     a user of the `User` associatedtype from the user passed as argument.
     
     - Parameters:
        - user: User created by a LoginProvider service when its own
            login was succesful.
     
     - Returns: A SignalProducer that can send the User logged in
     or the SessionServiceError if not.
     If the creation of the user is successful, the SignalProducer
     returned must take care of:
        sending the user to the observers and
        updating the currentUser and currentProviderName properties.
     If not, the SignalProducer returned
     must take care of:
        sending the error to the observer.
     */
    func logIn(withUser user: LoginProviderUserType) -> SignalProducer<User, SessionServiceError>
    
    /**
         This method takes care of validating and signing up.
         
         - Returns: A SignalProducer that can send the User logged in
         or the SessionServiceError if not.
         If the credentials are valid, the SignalProducer returned
         must take care of:
             sending the user to the observers and
             updating the currentUser and currentProviderName properties.
         If the credentials aren't valid, the SignalProducer returned
         must take care of:
             sending the error to the observer.
    */
    func signUp(withUsername username: String?, email: Email, password: String) -> SignalProducer<User, SessionServiceError>
    
}

internal extension SessionServiceError {
    
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
        case let .loginProviderError(_, error):
            return error.localizedMessage
        }
    }
    
}
