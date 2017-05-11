//
//  LoginProvider.swift
//  Authentication
//
//  Created by Gustavo Cairo on 1/13/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

/**
    Protocol that all users returned by
    login providers should implement.
 */
public protocol LoginProviderUser {}

/**
 This enum lists all the possible user types
 login providers can return.
 
 If a service you plan to use is not listed,
 you may use `custom` as your user type, and
 name it.
 */
public enum LoginProviderUserType {
    case facebook(user: FacebookLoginProviderUser)
    case custom(name: String, user: LoginProviderUser)
}

public protocol LoginProviderError: Error {

    /**
         Message to show the user to describe
         the error.
         
         - warning: This message must be localized to the
         current language on the device.
     */
    var localizedMessage: String { get }
    
}

public struct SimpleLoginProviderError: LoginProviderError {
    
    public let localizedMessage: String
    
    public init(localizedMessage: String) {
        self.localizedMessage = localizedMessage
    }
    
}

/**
     Protocol that all users returned by
     login providers should implement.
 */
public enum LoginProviderErrorType: Error {
    case facebook(error: FacebookLoginProviderError)
    case custom(name: String, error: LoginProviderError)
}

internal extension LoginProviderErrorType {

    var sessionServiceError: SessionServiceError {
        switch self {
        case let .facebook(error: error): return .loginProviderError(name: FacebookLoginProvider.name, error: error)
        case let .custom(name: name, error: error): return .loginProviderError(name: name, error: error)
        }
    }
    
}

/**
    Protocol that all login provider configurations
    should implement.
 */
public protocol LoginProviderConfiguration {}

/**
    Protocol that all LoginProviders must implement.
*/
public protocol LoginProvider {
    
    /**
        Name to identify the provider in the process.
        
        It will be used for login provider user and error types.
    */
    static var name: String { get }
    
    /**
         Signal that sends the user created as a result of
         the login triggered by the button in the LoginProvider.
     */
    var userSignal: Signal<LoginProviderUserType, NoError> { get }
    
    /**
         Signal that sends the errors caught as a result of
         the login triggered by the button in the LoginProvider.
     */
    var errorSignal: Signal<LoginProviderErrorType, NoError> { get }
    
    /**
        Returns the view that should be used as the button for
        your login provider.
 
        You should take care of setting this view up. That includes
        adding the necessary actions that would perform the API calls
        to use the provider when tapped.
     
        - warning: This function should return a different instance of
            the button each time it is called
            (so to be able to have it in login and signup screens)
    */
    func createButton() -> UIView

    /**
        Returns a SignalProducer that takes care of logging out the user
        from the login service.
    */
    func logOut() -> SignalProducer<(), LoginProviderErrorType>
    
}
