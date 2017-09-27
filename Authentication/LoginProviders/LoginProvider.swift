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
public protocol LoginProviderUser { }

/**
 This enum lists all the possible user types
 login providers can return.
 
 If a service you plan to use is not listed,
 you may use `custom` as your user type, and
 name it.
 */
public enum LoginProviderUserType {
    case facebook(user: FacebookLoginProviderUser)
    case google(user: GoogleLoginProviderUser)
    case custom(name: String, user: LoginProviderUser)

    public var providerName: String {
        switch self {
        case .facebook: return FacebookLoginProvider.name
        case .google: return GoogleLoginProvider.name
        case let .custom(name: name, user: _): return name
        }
    }
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
    case google(error: GoogleLoginProviderError)
    case custom(name: String, error: LoginProviderError)
}

internal extension LoginProviderErrorType {

    internal var sessionServiceError: SessionServiceError {
        switch self {
        case let .facebook(error: error): return .loginProviderError(name: FacebookLoginProvider.name, error: error)
        case let .google(error: error): return .loginProviderError(name: GoogleLoginProvider.name, error: error)
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
        Returns the current user if the user is logged in to this
        provider's service, or .none if it's not logged in.
     */
    var currentUser: LoginProviderUserType? { get }

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
    
    /**
        Handles url opening process:
            if the provider recognizes the url, it will react accordingly and return true. It should receive the same arguments as your app's AppDelegate does for this.
            if the provider doesn't recognize the url, it will return false.
    */
    func handleUrl(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    
    /**
        Handles the initializing of the provider so that it works as expected.
        It's used for example for recognizing a user that had already logged in to this app through this provider before.
        For this to work correctly, it should receive the same arguments your app's AppDelegate does for this.
        Returns true if the provider could be correctly initialized.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    
}
