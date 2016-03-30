//
//  LoginViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol Renderable {
    
    func render()
    
}

public protocol LoginViewType: Renderable {
    
    var view: UIView { get }
    
    var logoImageView: UIImageView { get }
    
    var emailLabel: UILabel? { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel? { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var logInButton: UIButton { get }
    var logInErrorLabel: UILabel? { get }
    
    var registerButton: UIButton { get }
    var recoverPasswordButton: UIButton { get }
    
    var emailTextFieldValid: Bool { get set }
    var emailTextFieldSelected: Bool { get set }
    var passwordTextFieldValid: Bool { get set }
    var passwordTextFieldSelected: Bool { get set }
    var logInButtonEnabled: Bool { get set }
    var logInButtonPressed: Bool { get set }
    var showPassword: Bool { get set }
    
}

public extension LoginViewType where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

public final class LoginView: UIView, LoginViewType {
    
    public lazy var delegate: LoginViewDelegate = DefaultLoginViewDelegate()
    
    public var logoImageView: UIImageView { return logoImageViewOutlet }
    @IBOutlet weak var logoImageViewOutlet: UIImageView!
    
    public var emailLabel: UILabel? { return .None }
    
    public var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    
    public var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet {
            emailValidationMessageLabelOutlet.text = " "
        }
    }
    
    public var passwordLabel: UILabel? { return .None }
    
    public var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!

    public var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! {
        didSet {
            passwordValidationMessageLabelOutlet.text = " "
        }
    }
    
    public var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton!
    
    public var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton! {
        didSet {
            logInButtonOutlet.layer.cornerRadius = 8.0
        }
    }
    
    public var logInErrorLabel: UILabel? { return logInErrorLabelOutlet }
    @IBOutlet weak var logInErrorLabelOutlet: UILabel! {
        didSet {
            logInErrorLabelOutlet.text = " "
        }
    }
    
    public var registerButton: UIButton { return registerButtonOutlet }
    @IBOutlet weak var registerButtonOutlet: UIButton!

    public var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton!
    
    public var activityIndicator: UIActivityIndicatorView? { return .None }
    
    
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet weak var toRegisterLabel: UILabel! {
        didSet {
            toRegisterLabel.text = "login-view.to-register-label".localized
        }
    }
    
    
    public var emailTextFieldValid: Bool = true {
        didSet {
            let color: CGColor
            if emailTextFieldValid {
                color = UIColor.clearColor().CGColor
            } else {
                color = UIColor.redColor().CGColor
            }
            emailTextFieldViewOutlet.layer.borderColor = color
        }
    }
    
    public var emailTextFieldSelected: Bool = false
    
    public var passwordTextFieldValid: Bool = true {
        didSet {
            let color: CGColor
            if passwordTextFieldValid {
                color = UIColor.clearColor().CGColor
            } else {
                color = UIColor.redColor().CGColor
            }
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = color
        }
    }
    
    public var passwordTextFieldSelected = false

    public var logInButtonEnabled: Bool = true {
        didSet {
            let alpha: CGFloat
            if logInButtonEnabled {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
            logInButton.alpha = alpha
        }
    }
    
    public var logInButtonPressed = false {
        didSet {
            let alpha: CGFloat
            if logInButtonPressed {
                alpha = 1.5
            } else {
                alpha = 1.0
            }
            logInButton.alpha = alpha
        }
    }
    
    public var showPassword: Bool = false {
        didSet {
            // Changing enabled property for the
            // font setting to take effect.
            passwordTextField.enabled = false
            passwordTextField.secureTextEntry = !showPassword
            passwordTextField.enabled = true
            passwordTextField.font = UIFont.systemFontOfSize(14)
        }
    }
    
    public func render() {
        activityIndicator?.hidesWhenStopped = true
        
        emailTextFieldValid = true
        passwordTextFieldValid = true
        logInButtonEnabled = false
        showPassword = false
        
        //Configure colour palette
        //Configure fonts
        delegate.configureView(self)
    }
    
}

extension LoginView: NibViewLoader {
    
    typealias NibLoadableViewType = LoginView
    
}
