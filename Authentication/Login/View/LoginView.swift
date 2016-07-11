//
//  LoginViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

public protocol LoginViewType: Renderable, LoginFormType {
    
    var logoImageView: UIImageView { get }
    
    var signupLabel: UILabel { get }
    var signupButton: UIButton { get }
    var recoverPasswordButton: UIButton { get }
    
}

public final class LoginView: UIView, LoginViewType, NibLoadable {
    
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
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! {
        didSet {
            passwordVisibilityButtonOutlet.hidden = true
        }
    }
    
    public var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton! {
        didSet {
            logInButtonOutlet.layer.cornerRadius = 6.0
        }
    }
    
    public var logInErrorLabel: UILabel? { return logInErrorLabelOutlet }
    @IBOutlet weak var logInErrorLabelOutlet: UILabel! {
        didSet {
            logInErrorLabelOutlet.text = " "
        }
    }
    
    public var signupButton: UIButton { return signupButtonOutlet }
    @IBOutlet weak var signupButtonOutlet: UIButton!

    public var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton!
    
    public var activityIndicator: UIActivityIndicatorView? { return .None }
    
    
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    public var signupLabel: UILabel { return toSignupLabel }
    @IBOutlet weak var toSignupLabel: UILabel!
    
    @IBOutlet var emailErrorsHeightConstraint: NSLayoutConstraint!      // not weak
    @IBOutlet var passwordErrorsHeightConstraint: NSLayoutConstraint!   // not weak

    
    public var emailTextFieldValid: Bool = true {
        didSet {
            if !emailTextFieldSelected {
                let color: CGColor
                if emailTextFieldValid {
                    color = delegate.colorPalette.textfieldsNormal.CGColor
                    emailErrorsHeightConstraint.constant = 0
                    emailErrorsHeightConstraint.active = true
                } else {
                    color = delegate.colorPalette.textfieldsError.CGColor
                    emailErrorsHeightConstraint.active = false
                }
                emailTextFieldViewOutlet.layer.borderColor = color
            } else {
                emailErrorsHeightConstraint.constant = 0
                emailErrorsHeightConstraint.active = true
            }
        }
    }
    
    public var emailTextFieldSelected: Bool = false {
        didSet {
            if emailTextFieldSelected {
                emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
                emailErrorsHeightConstraint.constant = 0
                emailErrorsHeightConstraint.active = true
            } else {
                let valid = emailTextFieldValid
                emailTextFieldValid = valid
            }
        }
    }
    
    public var passwordTextFieldValid: Bool = true {
        didSet {
            if !passwordTextFieldSelected {
                let color: CGColor
                if passwordTextFieldValid {
                    color = delegate.colorPalette.textfieldsNormal.CGColor
                    passwordErrorsHeightConstraint.constant = 0
                    passwordErrorsHeightConstraint.active = true
                } else {
                    color = delegate.colorPalette.textfieldsError.CGColor
                    passwordErrorsHeightConstraint.active = false
                }
                passwordTextFieldAndButtonViewOutlet.layer.borderColor = color
            } else {
                passwordErrorsHeightConstraint.constant = 0
                passwordErrorsHeightConstraint.active = true
            }
        }
    }
    
    public var passwordTextFieldSelected = false {
        didSet {
            if passwordTextFieldSelected {
                passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
                passwordErrorsHeightConstraint.constant = 0
                passwordErrorsHeightConstraint.active = true
            } else {
                let valid = passwordTextFieldValid
                passwordTextFieldValid = valid
            }
        }
    }
    
    public var logInButtonEnabled: Bool = true {
        didSet {
            let colorPalette = delegate.colorPalette
            let color = logInButtonEnabled ? colorPalette.mainButtonEnabled : colorPalette.mainButtonDisabled
            logInButton.backgroundColor = color
        }
    }
    
    public var logInButtonPressed = false {
        didSet {
            let colorPalette = delegate.colorPalette
            let color = logInButtonPressed ? colorPalette.mainButtonExecuted : colorPalette.mainButtonEnabled
            logInButton.backgroundColor = color
            emailErrorsHeightConstraint.constant = 0
            emailErrorsHeightConstraint.active = true
            passwordErrorsHeightConstraint.constant = 0
            passwordErrorsHeightConstraint.active = true
        }
    }
    
    public var showPassword: Bool = false {
        didSet {
            // Changing enabled property for the
            // font setting to take effect, which is
            // necessary for it not to shrink.
            passwordTextField.enabled = false
            passwordTextField.secureTextEntry = !showPassword
            passwordTextField.enabled = true
            passwordTextField.font = delegate.fontPalette.textfields
        }
    }
    
    public func render() {
        activityIndicator?.hidesWhenStopped = true
        
        emailTextFieldValid = true
        passwordTextFieldValid = true
        emailTextFieldSelected = false
        passwordTextFieldSelected = false
        logInButtonEnabled = false
        showPassword = false
        
        //Configure colour palette
        //Configure fonts
        delegate.configureView(self)
    }
    
}
