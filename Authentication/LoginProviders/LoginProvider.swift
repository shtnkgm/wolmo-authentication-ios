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
    Protocol that all login provider configurations
    should implement.
 */
public protocol LoginProviderConfiguration {}

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

/**
    Protocol that all LoginProviders must implement.
*/
public protocol LoginProvider {
    
    /**
        Signal that sends the user created as a result of
        the login triggered by the button in the LoginProvider.
     */
    var userSignal: Signal<LoginProviderUserType, NoError> { get }
    
    /**
        This is the view that should be used as the button for
        your login provider.
 
        You should take care of setting this view up. That includes
        adding the necessary actions that would perform the API calls
        to use the provider when tapped.
    */
    var button: UIView { get }
    
}
