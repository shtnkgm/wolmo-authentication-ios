//
//  LoginControllerConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/23/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
    Class for configuring the login controller.
 */
public final class LoginControllerConfiguration {
    
    public let viewModel: LoginViewModelType
    public let viewFactory: () -> LoginViewType
    public let transitionDelegate: LoginControllerTransitionDelegate //swiftlint:disable:this weak_delegate
    public let delegate: LoginControllerDelegate //swiftlint:disable:this weak_delegate
    public let loginProviders: [LoginProvider]
    
    /**
        Initializes a login controller configuration with the view model,
        delegate, a factory method for the login view and transition 
        delegate for the login controller to use.
     
        - Parameters:
             - viewModelFactory: factory method that creates the
             view model to bind to and use, given a list of LoginProviders.
             - viewFactory: factory method to call only once
             to get the login view to use.
             - transitionDelegate: delegate to handle events that fire a
             transition, like selecting registration or recover password.
             - delegate: delegate which adds behaviour to certain events,
             like handling a login error or selecting log in option.
             The default delegate is provided.
             - loginProviders: list of the login providers to use.
    */
    internal init(viewModelFactory: @escaping ([LoginProvider]) -> LoginViewModelType,
                  viewFactory: @escaping ([LoginProvider]) -> LoginViewType,
                  transitionDelegate: LoginControllerTransitionDelegate,
                  delegate: LoginControllerDelegate = DefaultLoginControllerDelegate(),
                  loginProviders: [LoginProvider]) {
        self.viewModel = viewModelFactory(loginProviders)
        self.viewFactory = { viewFactory(loginProviders) }
        self.transitionDelegate = transitionDelegate
        self.delegate = delegate
        self.loginProviders = loginProviders
    }
    
}
