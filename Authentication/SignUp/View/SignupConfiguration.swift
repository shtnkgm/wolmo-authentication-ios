//
//  SignupConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/15/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Class for configuring the signup controller.
 */
public final class SignupControllerConfiguration {
    
    public let viewModel: SignupViewModelType
    public let viewFactory: () -> SignupViewType
    public let delegate: SignupControllerDelegate //swiftlint:disable:this weak_delegate
    public let transitionDelegate: SignupControllerTransitionDelegate //swiftlint:disable:this weak_delegate
    public let termsAndServicesURL: URL
    
    /**
         Initializes a signup controller configuration with the view model,
         delegate, a factory method for the signup view and transition
         delegate for the signup controller to use.
     
         - Parameters:
             - viewModel: view model to bind to and use.
             - viewFactory: factory method to call only once
             to get the signup view to use.
             - transitionDelegate: delegate to handle events that fire a
             transition, like selecting login.
             - delegate: delegate which adds behaviour to certain events,
             like handling a signup error or selecting sign up option.
             The default delegate is provided.
     */
    internal init(viewModel: SignupViewModelType,
                  viewFactory: @escaping () -> SignupViewType,
                  transitionDelegate: SignupControllerTransitionDelegate,
                  delegate: SignupControllerDelegate = DefaultSignupControllerDelegate(),
                  termsAndServicesURL: URL) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        self.delegate = delegate
        self.transitionDelegate = transitionDelegate
        self.termsAndServicesURL = termsAndServicesURL
    }
    
}
