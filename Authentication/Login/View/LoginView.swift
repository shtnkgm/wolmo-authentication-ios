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

internal final class LoginView: UIView, LoginViewType, NibLoadable {
    
    internal lazy var delegate: LoginViewDelegate = DefaultLoginViewDelegate()
    
    internal var logoImageView: UIImageView { return logoImageViewOutlet }
    @IBOutlet weak var logoImageViewOutlet: UIImageView!
    
    internal var emailLabel: UILabel?
    
    internal var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField! {
        didSet { emailTextFieldOutlet.placeholder = emailPlaceholderText }
    }
    
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet { emailValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordLabel: UILabel?
    
    internal var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! {
        didSet { passwordTextFieldOutlet.placeholder = passwordPlaceholderText }
    }

    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! {
        didSet { passwordValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! {
        didSet { passwordVisibilityButtonOutlet.hidden = true }
    }
    
    internal var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton! {
        didSet {
            logInButtonOutlet.layer.cornerRadius = 6.0
            logInButtonOutlet.setTitle(logInButtonTitle, forState: .Normal)
        }
    }
    
    internal var logInErrorLabel: UILabel? { return .None }
    
    internal var signupLabel: UILabel { return toSignupLabel }
    @IBOutlet weak var toSignupLabel: UILabel! {
        didSet { toSignupLabel.text = signupLabelText }
    }
    
    internal var signupButton: UIButton { return signupButtonOutlet }
    @IBOutlet weak var signupButtonOutlet: UIButton! {
        didSet { signupButton.setTitle(signupButtonTitle, forState: .Normal) }
    }

    internal var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton! {
        didSet { recoverPasswordButton.setTitle(recoverPasswordButtonTitle, forState: .Normal) }
    }
    
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

    
    internal var emailTextFieldValid = true {
        didSet { emailTextFieldValidWasSet() }
    }
    
    internal var emailTextFieldSelected = false {
        didSet { emailTextFieldSelectedWasSet() }
    }
    
    internal var passwordTextFieldValid = true {
        didSet { passwordTextFieldValidWasSet() }
    }
    
    internal var passwordTextFieldSelected = false {
        didSet { passwordTextFieldSelectedWasSet() }
    }
    
    internal var logInButtonEnabled = true {
        didSet { logInButtonEnabledWasSet() }
    }
    
    internal var logInButtonPressed = false {
        didSet { logInButtonPressedWasSet() }
    }
    
    internal var showPassword = false {
        didSet { showPasswordWasSet() }
    }
    
    internal func render() {
        emailTextFieldValid = true
        passwordTextFieldValid = true
        emailTextFieldSelected = false
        passwordTextFieldSelected = false
        logInButtonEnabled = false
        logInButtonPressed = false
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

public extension LoginViewType {
        
    public var emailText: String {
        return "login-view.email".localized
    }
    
    public var passwordText: String {
        return "login-view.password".localized
    }
    
    public var emailPlaceholderText: String {
        return "login-view.email-placeholder".localized
    }
    
    public var passwordPlaceholderText: String {
        return "login-view.password-placeholder".localized
    }
    
    public var logInButtonTitle: String {
        return "login-view.login-button-title".localized
    }
    
    public var signupLabelText: String {
        return "login-view.to-signup-label".localized
    }
    
    public var signupButtonTitle: String {
        return "login-view.signup-button-title".localized
    }

    private var passwordVisibilityButtonTitle: String {
        return ("text-visibility-button-title." + (showPassword ? "false" : "true")).localized
    }
    
    public var recoverPasswordButtonTitle: String {
        return "login-view.recover-password-button-title".localized
    }
    
}
