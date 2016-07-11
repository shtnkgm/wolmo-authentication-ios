//
//  SignupViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

public protocol SignupViewType: Renderable, SignupFormType { }

public final class SignupView: UIView, SignupViewType {
    
    public lazy var delegate: SignupViewDelegate = DefaultSignupViewDelegate()
    
    //TODO return real objects
    public var usernameLabel: UILabel? { return .None }
    public var usernameTextField: UITextField? { return .None }
    public var usernameValidationMessageLabel: UILabel? { return .None }
    
    public var emailLabel: UILabel? { return .None }
    public var emailTextField: UITextField { return UITextField() }
    public var emailValidationMessageLabel: UILabel? { return .None }
    
    public var passwordLabel: UILabel? { return .None }
    public var passwordTextField: UITextField { return UITextField() }
    public var passwordValidationMessageLabel: UILabel? { return .None }
    public var passwordVisibilityButton: UIButton? { return .None }
    
    public var passwordConfirmLabel: UILabel? { return .None }
    public var passwordConfirmTextField: UITextField { return UITextField() }
    public var passwordConfirmValidationMessageLabel: UILabel? { return .None }
    public var passwordConfirmVisibilityButton: UIButton? { return .None }
    
    public var signupButton: UIButton { return UIButton() }
    public var signupErrorLabel: UILabel? { return .None }
    
    public var termsAndServicesButton: UIButton { return UIButton() }
    public var termsAndServicesLabel: UILabel? { return .None }
    
    public var usernameTextFieldValid: Bool = false
    public var usernameTextFieldSelected: Bool = false
    public var emailTextFieldValid: Bool = false
    public var emailTextFieldSelected: Bool = false
    public var passwordTextFieldValid: Bool = false
    public var passwordTextFieldSelected: Bool = false
    public var showPassword: Bool = false
    public var passwordConfirmationTextFieldValid: Bool = false
    public var passwordConfirmationTextFieldSelected: Bool = false
    public var showConfirmPassword: Bool = false
    public var signupButtonEnabled: Bool = false
    public var signupButtonPressed: Bool = false
    
    public func render() {
        
        delegate.configureView(self)
        
    }
    
}
