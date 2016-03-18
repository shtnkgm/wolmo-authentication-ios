//
//  RegisterViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol RegisterViewType {
 
    var view: UIView { get }
    
    var usernameLabel: UILabel { get }
    var usernameTextField: UITextField { get }
    var usernameValidationMessageLabel: UILabel? { get }
    
    var emailLabel: UILabel { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var passwordConfirmationLabel: UILabel { get }
    var passwordConfirmationTextField: UITextField { get }
    var passwordConfirmationValidationMessageLabel: UILabel? { get }
    var passwordConfirmationVisibilityButton: UIButton? { get }
    
    var registerButton: UIButton { get }
    var registerErrorLabel: UILabel? { get }
    
    var activityIndicator: UIActivityIndicatorView { get }
    
    var passwordTextFieldValid: Bool { get set }
    var emailTextFieldValid: Bool { get set }
    var registerButtonEnabled: Bool { get set }
    
    
}
