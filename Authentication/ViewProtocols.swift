//
//  ViewProtocols.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/11/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

public protocol Renderable {
    
    var view: UIView { get }
    
    func render()
    
}

public extension Renderable where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}


public protocol AuthenticationFormType {
    
    var emailLabel: UILabel? { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var emailTextFieldValid: Bool { get set }
    var emailTextFieldSelected: Bool { get set }
    
    var passwordLabel: UILabel? { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var passwordTextFieldValid: Bool { get set }
    var passwordTextFieldSelected: Bool { get set }
    var showPassword: Bool { get set }
    
}

public protocol LoginFormType: AuthenticationFormType {

    var logInButton: UIButton { get }
    var logInErrorLabel: UILabel? { get }
    
    var logInButtonEnabled: Bool { get set }
    var logInButtonPressed: Bool { get set }

}

public protocol SignupFormType: AuthenticationFormType {

    var usernameLabel: UILabel? { get }
    var usernameTextField: UITextField? { get }
    var usernameValidationMessageLabel: UILabel? { get }
    
    var usernameTextFieldValid: Bool { get set }
    var usernameTextFieldSelected: Bool { get set }

    var passwordConfirmLabel: UILabel? { get }
    var passwordConfirmTextField: UITextField? { get }
    var passwordConfirmValidationMessageLabel: UILabel? { get }
    var passwordConfirmVisibilityButton: UIButton? { get }
    
    var passwordConfirmationTextFieldValid: Bool { get set }
    var passwordConfirmationTextFieldSelected: Bool { get set }
    var showConfirmPassword: Bool { get set }
    
    var signupButton: UIButton { get }
    var signupErrorLabel: UILabel? { get }
    
    var signupButtonEnabled: Bool { get set }
    var signupButtonPressed: Bool { get set }
    
    var termsAndServicesButton: UIButton { get }
    var termsAndServicesLabel: UILabel? { get }
    
}
