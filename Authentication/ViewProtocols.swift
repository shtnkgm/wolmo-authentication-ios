//
//  ViewProtocols.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/11/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents a component that can be
     visually displayed on the screen.
 */
public protocol Renderable {
    
    var view: UIView { get }
    
    func render()
    
}

public extension Renderable where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

/**
     Represents an authentication form
     with its minimum elements necessary
     to be able to authenticate, and
     properties to handle its states.
 */
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
    var passwordVisible: Bool { get set }
    
}

public extension AuthenticationFormType {
    
    var emailLabel: UILabel? { return .None }
    var emailValidationMessageLabel: UILabel? { return .None }
    
    var passwordLabel: UILabel? { return .None }
    var passwordValidationMessageLabel: UILabel? { return .None }
    var passwordVisibilityButton: UIButton? { return .None }
    
}

/**
     Represents a login form with its
     minimum elements necessary to
     authenticate and start login action,
     and properties to handle its states.
 */
public protocol LoginFormType: AuthenticationFormType {

    var logInButton: UIButton { get }
    var logInErrorLabel: UILabel? { get }
    
    var logInButtonEnabled: Bool { get set }
    var logInButtonPressed: Bool { get set }

}

public extension LoginFormType {
    
    var logInErrorLabel: UILabel? { return .None }
    
}

/**
     Represents a signup form with its
     most common elements used to
     authenticate and start signup action,
     and properties to handle its states.
 */
public protocol SignupFormType: AuthenticationFormType {

    var usernameLabel: UILabel? { get }
    var usernameTextField: UITextField? { get }
    var usernameValidationMessageLabel: UILabel? { get }
    func hideUsernameElements()
    
    var usernameTextFieldValid: Bool { get set }
    var usernameTextFieldSelected: Bool { get set }

    var passwordConfirmLabel: UILabel? { get }
    var passwordConfirmTextField: UITextField? { get }
    var passwordConfirmValidationMessageLabel: UILabel? { get }
    var passwordConfirmVisibilityButton: UIButton? { get }
    func hidePasswordConfirmElements()
    
    var passwordConfirmationTextFieldValid: Bool { get set }
    var passwordConfirmationTextFieldSelected: Bool { get set }
    var passwordConfirmationVisible: Bool { get set }
    
    var signUpButton: UIButton { get }
    var signUpErrorLabel: UILabel? { get }
    
    var signUpButtonEnabled: Bool { get set }
    var signUpButtonPressed: Bool { get set }
    
    var termsAndServicesTextView: UITextView { get }
    func setTermsAndServicesText(url: NSURL)
    
}

public extension SignupFormType {
    
    var usernameLabel: UILabel? { return .None }
    var usernameTextField: UITextField? { return .None }
    var usernameValidationMessageLabel: UILabel? { return .None }
    
    var passwordConfirmLabel: UILabel? { return .None }
    var passwordConfirmTextField: UITextField? { return .None }
    var passwordConfirmValidationMessageLabel: UILabel? { return .None }
    var passwordConfirmVisibilityButton: UIButton? { return .None }
    
    var signUpErrorLabel: UILabel? { return .None }
    
}
