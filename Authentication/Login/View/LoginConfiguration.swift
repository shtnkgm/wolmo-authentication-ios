//
//  LoginConfiguration.swift
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
    public let delegate: LoginControllerDelegate //swiftlint:disable:this weak_delegate
    public let transitionDelegate: LoginControllerTransitionDelegate //swiftlint:disable:this weak_delegate
    
    /**
        Initializes a login controller configuration with the view model,
        delegate, a factory method for the login view and transition 
        delegate for the login controller to use.
     
        - Parameters:
             - viewModel: view model to bind to and use.
             - viewFactory: factory method to call only once
             to get the login view to use.
             - transitionDelegate: delegate to handle events that fire a
             transition, like selecting registration or recover password.
             - delegate: delegate which adds behaviour to certain events,
             like handling a login error or selecting log in option.
             The default delegate is provided.
    */
    internal init(viewModel: LoginViewModelType,
                  viewFactory: @escaping () -> LoginViewType,
                  transitionDelegate: LoginControllerTransitionDelegate,
                  delegate: LoginControllerDelegate = DefaultLoginControllerDelegate()) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        self.delegate = delegate
        self.transitionDelegate = transitionDelegate
    }
    
}
