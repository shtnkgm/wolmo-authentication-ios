//
//  LogInViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol Renderable {
    
    func render()
    
}

public protocol LogInViewType: Renderable {
    
    var emailLabel: UILabel { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: PasswordVisibilityButton? { get }
    
    var loginButton: UIButton { get }
    var registerButton: UIButton { get }
    var termsAndService: UIButton? { get }
    
}

final class LoginView: UIView, LogInViewType {  //TODO preguntar UIView en protocolo
    
    //TODO return real objects
    var emailLabel: UILabel { return UILabel() }
    var emailTextField: UITextField { return UITextField() }
    var emailValidationMessageLabel: UILabel? { return .None }
    
    var passwordLabel: UILabel { return UILabel() }
    var passwordTextField: UITextField { return UITextField() }
    var passwordValidationMessageLabel: UILabel? { return .None }
    var passwordVisibilityButton: PasswordVisibilityButton? { return .None }
    
    var loginButton: UIButton { return UIButton() }
    var registerButton: UIButton { return UIButton() }
    var termsAndService: UIButton? { return .None }
    
    func render() {
        // TODO this function should configure each view elements and
        // in case we are doing the layout programatically it should
        // layout all its components
    }
    
}