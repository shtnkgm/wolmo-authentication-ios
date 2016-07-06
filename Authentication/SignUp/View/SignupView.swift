//
//  SignupViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupViewType: Renderable {
 
    var view: UIView { get }
    
    var usernameLabel: UILabel? { get }
    var usernameTextField: UITextField? { get }
    var usernameValidationMessageLabel: UILabel? { get }
    
    var emailLabel: UILabel? { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel? { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var passwordConfirmLabel: UILabel? { get }
    var passwordConfirmTextField: UITextField { get }
    var passwordConfirmValidationMessageLabel: UILabel? { get }
    var passwordConfirmVisibilityButton: UIButton? { get }
    
    var signupButton: UIButton { get }
    var signupErrorLabel: UILabel? { get }
    
    var termsAndServicesButton: UIButton { get }
    var termsAndServicesLabel: UILabel? { get }
    
    var usernameTextFieldValid: Bool { get set }
    var usernameTextFieldSelected: Bool { get set }
    var emailTextFieldValid: Bool { get set }
    var emailTextFieldSelected: Bool { get set }
    var passwordTextFieldValid: Bool { get set }
    var passwordTextFieldSelected: Bool { get set }
    var passwordConfirmationTextFieldValid: Bool { get set }
    var passwordConfirmationTextFieldSelected: Bool { get set }
    var signupButtonEnabled: Bool { get set }
    var signupButtonPressed: Bool { get set }
    
}

public extension SignupViewType where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

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
    public var passwordConfirmationTextFieldValid: Bool = false
    public var passwordConfirmationTextFieldSelected: Bool = false
    public var signupButtonEnabled: Bool = false
    public var signupButtonPressed: Bool = false
    
    public func render() {
        
        delegate.configureView(self)
        
    }
    
}
