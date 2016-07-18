//
//  SignupConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/15/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
 Protocol for handling transition events occured during signup.
 */
public protocol SignupControllerTransitionDelegate {
    
    func onLogin(controller: SignupController)
    
}

/**
 Class for configuring the singup controller.
 Includes all information required:
 view factory method,
 view model,
 signup controller delegate and
 signup controller transition delegate.
 */
public final class SignupControllerConfiguration {
    
    public let viewModel: SignupViewModelType
    public let viewFactory: () -> SignupViewType
    public let delegate: SignupControllerDelegate
    public let transitionDelegate: SignupControllerTransitionDelegate
    
    /**
     Initializes a signup controller configuration with the view model,
     delegate, a factory method for the signup view and transition
     delegate for the signup controller to use.
     
     - Params:
     - viewModel: view model to bind to and use.
     - viewFactory: factory method to call only once
     to get the signup view to use.
     - transitionDelegate: delegate to handle events that fire a
     transition, like selecting login.
     - delegate: delegate which adds behaviour to certain events,
     like handling a signup error or selecting sign up option.
     A default delegate is provided.
     
     - Returns: A valid configuration
     */
    // swiftlint:disable valid_docs
    init(viewModel: SignupViewModelType,
    // swiftlint:enable valid_docs
        viewFactory: () -> SignupViewType,
        transitionDelegate: SignupControllerTransitionDelegate,
        delegate: SignupControllerDelegate = DefaultSignupControllerDelegate()) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        self.delegate = delegate
        self.transitionDelegate = transitionDelegate
    }
    
}
