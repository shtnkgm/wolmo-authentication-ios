//
//  AuthenticationViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct AuthenticationViewConfiguration {
    
    public let loginConfiguration: LoginViewConfiguration
    public let signupConfiguration: SignupViewConfiguration
    
    public init() {
        loginConfiguration = LoginViewConfiguration()
        signupConfiguration = SignupViewConfiguration()
    }
    
    public init(loginViewConfiguration: LoginViewConfiguration, signupViewConfiguration: SignupViewConfiguration = SignupViewConfiguration()) {
        loginConfiguration = loginViewConfiguration
        signupConfiguration = signupViewConfiguration
    }
    
    public init(signupViewConfiguration: SignupViewConfiguration, loginViewConfiguration: LoginViewConfiguration = LoginViewConfiguration()) {
        loginConfiguration = loginViewConfiguration
        signupConfiguration = signupViewConfiguration
    }
    
}
