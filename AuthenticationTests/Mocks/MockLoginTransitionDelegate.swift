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
    
    func onLoginSuccess(controller: LoginController) { }
    
    func toSignup(controller: LoginController) { }
    
    func toRecoverPassword(controller: LoginController) { }
    
}
