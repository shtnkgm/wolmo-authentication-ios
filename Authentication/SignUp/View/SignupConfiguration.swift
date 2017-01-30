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
    public let loginProviders: [LoginProvider]
    
    /**
         Initializes a signup controller configuration with the view model,
         delegate, a factory method for the signup view and transition
         delegate for the signup controller to use.
     
         - Parameters:
             - viewModelFactory: factory method that creates the 
             view model to bind to and use, given a list of LoginProviders.
             - viewFactory: factory method to call only once
             to get the signup view to use.
             - transitionDelegate: delegate to handle events that fire a
             transition, like selecting login.
             - delegate: delegate which adds behaviour to certain events,
             like handling a signup error or selecting sign up option.
             The default delegate is provided.
             - loginProviders: list of the login providers to use.
     */
    internal init(viewModelFactory: @escaping ([LoginProvider]) -> SignupViewModelType,
                  viewFactory: @escaping ([LoginProvider]) -> SignupViewType,
                  transitionDelegate: SignupControllerTransitionDelegate,
                  delegate: SignupControllerDelegate = DefaultSignupControllerDelegate(),
                  termsAndServicesURL: URL,
                  loginProviders: [LoginProvider]) {
        self.viewModel = viewModelFactory(loginProviders)
        self.viewFactory = { viewFactory(loginProviders) }
        self.delegate = delegate
        self.transitionDelegate = transitionDelegate
        self.termsAndServicesURL = termsAndServicesURL
        self.loginProviders = loginProviders
    }
    
}
