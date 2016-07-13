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
    @IBOutlet weak var emailTextFieldOutlet: UITextField! {
        didSet {
            emailTextFieldOutlet.placeholder = emailPlaceholderText
        }
    }
    
    public var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet {
            emailValidationMessageLabelOutlet.text = " "
        }
    }
    
    public var passwordLabel: UILabel? { return .None }
    
    public var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! {
        didSet {
            passwordTextFieldOutlet.placeholder = passwordPlaceholderText
        }
    }

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
            logInButton.setTitle(logInButtonTitle, forState: .Normal)
        }
    }
    
    public var logInErrorLabel: UILabel? { return logInErrorLabelOutlet }
    @IBOutlet weak var logInErrorLabelOutlet: UILabel! {
        didSet {
            logInErrorLabelOutlet.text = " "
        }
    }
    
    public var signupLabel: UILabel { return toSignupLabel }
    @IBOutlet weak var toSignupLabel: UILabel! {
        didSet {
            toSignupLabel.text = signupLabelText
        }
    }
    
    public var signupButton: UIButton { return signupButtonOutlet }
    @IBOutlet weak var signupButtonOutlet: UIButton! {
        didSet {
            signupButton.setTitle(signupButtonTitle, forState: .Normal)
        }
    }

    public var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton! {
        didSet {
            recoverPasswordButton.setTitle(recoverPasswordButtonTitle, forState: .Normal)
        }
    }
    
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
    
    @IBOutlet var emailErrorsHeightConstraint: NSLayoutConstraint!      // not weak
    @IBOutlet var passwordErrorsHeightConstraint: NSLayoutConstraint!   // not weak

    
    public var emailTextFieldValid: Bool = true {
        didSet { emailTextFieldValidWasSet() }
    }
    
    public var emailTextFieldSelected: Bool = false {
        didSet { emailTextFieldSelectedWasSet() }
    }
    
    public var passwordTextFieldValid: Bool = true {
        didSet { passwordTextFieldValidWasSet() }
    }
    
    public var passwordTextFieldSelected = false {
        didSet { passwordTextFieldSelectedWasSet() }
    }
    
    public var logInButtonEnabled: Bool = true {
        didSet { logInButtonEnabledWasSet() }
    }
    
    public var logInButtonPressed = false {
        didSet { logInButtonPressedWasSet() }
    }
    
    public var showPassword: Bool = false {
        didSet { showPasswordWasSet() }
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

private extension LoginView {
    
    private func emailTextFieldValidWasSet() {
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
    
    
    private func emailTextFieldSelectedWasSet() {
        if emailTextFieldSelected {
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            emailErrorsHeightConstraint.constant = 0
            emailErrorsHeightConstraint.active = true
        } else {
            let valid = emailTextFieldValid
            emailTextFieldValid = valid
        }
    }
    
    
    private func passwordTextFieldValidWasSet() {
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
    
    
    private func passwordTextFieldSelectedWasSet() {
        if passwordTextFieldSelected {
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            passwordErrorsHeightConstraint.constant = 0
            passwordErrorsHeightConstraint.active = true
        } else {
            let valid = passwordTextFieldValid
            passwordTextFieldValid = valid
        }
    }
    
    private func logInButtonEnabledWasSet() {
        let colorPalette = delegate.colorPalette
        let color = logInButtonEnabled ? colorPalette.mainButtonEnabled : colorPalette.mainButtonDisabled
        logInButton.backgroundColor = color
    }
    
    private func logInButtonPressedWasSet() {
        let colorPalette = delegate.colorPalette
        let color = logInButtonPressed ? colorPalette.mainButtonExecuted : colorPalette.mainButtonEnabled
        logInButton.backgroundColor = color
        emailErrorsHeightConstraint.constant = 0
        emailErrorsHeightConstraint.active = true
        passwordErrorsHeightConstraint.constant = 0
        passwordErrorsHeightConstraint.active = true
    }
    
    private func showPasswordWasSet() {
        // Changing enabled property for the
        // font setting to take effect, which is
        // necessary for it not to shrink.
        passwordTextField.enabled = false
        passwordTextField.secureTextEntry = !showPassword
        passwordTextField.enabled = true
        passwordTextField.font = delegate.fontPalette.textfields
        passwordVisibilityButtonOutlet.setTitle(passwordVisibilityButtonTitle, forState: .Normal)
    }
    
}

private extension LoginView {
        
    private var emailText: String {
        return "login-view.email".localized
    }
    
    private var passwordText: String {
        return "login-view.password".localized
    }
    
    private var emailPlaceholderText: String {
        return "login-view.email-placeholder".localized
    }
    
    private var passwordPlaceholderText: String {
        return "login-view.password-placeholder".localized
    }
    
    private var logInButtonTitle: String {
        return "login-view.login-button-title".localized
    }
    
    private var signupLabelText: String {
        return "login-view.to-signup-label".localized
    }
    
    private var signupButtonTitle: String {
        return "login-view.signup-button-title".localized
    }
    
    private var passwordVisibilityButtonTitle: String {
        return ("login-view.password-visibility-button-title." + (showPassword ? "false" : "true")).localized
    }
    
    private var recoverPasswordButtonTitle: String {
        return "login-view.recover-password-button-title".localized
    }
    
}
