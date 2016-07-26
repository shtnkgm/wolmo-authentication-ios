//
//  AuthenticationViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//


/**
     Represents the view configurations able to
     be customized in all authentication process.
 
     Includes the login and signup view configurations.
 */
public struct AuthenticationViewConfiguration {
    
    public let loginConfiguration: LoginViewConfigurationType
    public let signupConfiguration: SignupViewConfigurationType
    
    public init(loginViewConfiguration: LoginViewConfigurationType = LoginViewConfiguration(),
                signupViewConfiguration: SignupViewConfigurationType) {
        loginConfiguration = loginViewConfiguration
        signupConfiguration = signupViewConfiguration
    }
    public init(loginViewConfiguration: LoginViewConfigurationType = LoginViewConfiguration(),
                 termsAndServicesURL: NSURL) {
        self.init(loginViewConfiguration: loginViewConfiguration, signupViewConfiguration: SignupViewConfiguration(termsAndServicesURL: termsAndServicesURL))
    }
    
}
