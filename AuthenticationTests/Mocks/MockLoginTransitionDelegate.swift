//
//  MockLoginTransitionDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/23/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import Authentication

final class MockLoginTransitionDelegate: LoginControllerTransitionDelegate {
    
    func onLoginSuccess(from controller: LoginController) { }
    
    func toSignup(from controller: LoginController) { }
    
    func toRecoverPassword(from controller: LoginController) { }
    
}
