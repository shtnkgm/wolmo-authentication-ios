//
//  LoginConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/23/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
    Protocol for handling transition events occured during login.
*/
public protocol LoginControllerTransitionDelegate {
    
    func onSignup(controller: LoginController)
    
    func onRecoverPassword(controller: LoginController)
    
}


/**
    Class for configuring the login controller.
    Includes all information required:
        view factory method,
        view model,
        login controller delegate and
        login controller transition delegate.
 */
public final class LoginControllerConfiguration {
    
    var viewModel: LoginViewModelType
    var viewFactory: () -> LoginViewType
    var delegate: LoginControllerDelegate
    var transitionDelegate: LoginControllerTransitionDelegate
    
    /**
        Initializes a login controller configuration with the view model,
        delegate, a factory method for the login view and transition 
        delegate for the login controller to use.
     
        - Params:
             - viewModel: view model to bind to and use.
             - viewFactory: factory method to call only once
             to get the login view to use.
             - transitionDelegate: delegate to handle events that fire a
             transition, like selecting registration or recover password.
             - delegate: delegate which adds behaviour to certain
             events, like handling a login error or selecting log in option.
             A default delegate is provided.
     
        - Returns: A valid configuration
    */
// swiftlint:disable valid_docs
    init(viewModel: LoginViewModelType,
// swiftlint:enable valid_docs
        viewFactory: () -> LoginViewType,
        transitionDelegate: LoginControllerTransitionDelegate,
        delegate: LoginControllerDelegate = DefaultLoginControllerDelegate()) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        self.delegate = delegate
        self.transitionDelegate = transitionDelegate
    }
    
}
