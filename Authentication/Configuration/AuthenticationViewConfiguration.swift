//
//  AuthenticationViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct AuthenticationViewConfiguration {
    
    public let loginConfiguration: LoginViewConfigurationType
    public let signupConfiguration: SignupViewConfigurationType
    
    public init(loginViewConfiguration: LoginViewConfigurationType = DefaultLoginViewConfiguration(), signupViewConfiguration: SignupViewConfigurationType = DefaultSignupViewConfiguration()) {
        loginConfiguration = loginViewConfiguration
        signupConfiguration = signupViewConfiguration
    }
    
}
