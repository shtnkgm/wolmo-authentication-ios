//
//  LoginViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Core


/**
     Represents the minimum required
     properties from a login view
     for it to be compatible with
     the framework.
 */
public protocol LoginViewType: Renderable, LoginFormType {
    
    var logoImageView: UIImageView { get }
    
    /* Navigation elements to other screens */
    var signupLabel: UILabel? { get }
    var signupButton: UIButton { get }
    var recoverPasswordLabel: UILabel? { get }
    var recoverPasswordButton: UIButton { get }
    
}

public extension LoginViewType {
    
    var signupLabel: UILabel? { return .None }
    
    var recoverPasswordLabel: UILabel? { return .None }
    
}

/** Default login view. */
internal final class LoginView: UIView, LoginViewType, NibLoadable {
    
    internal lazy var delegate: LoginViewDelegate = DefaultLoginViewDelegate()
    
    internal var logoImageView: UIImageView { return logoImageViewOutlet }
    @IBOutlet weak var logoImageViewOutlet: UIImageView!
    
    internal var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField! {
        didSet { emailTextFieldOutlet.placeholder = emailPlaceholderText }
    }
    
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet { emailValidationMessageLabelOutlet.text = "" }
    }
    
    internal var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! {
        didSet { passwordTextFieldOutlet.placeholder = passwordPlaceholderText }
    }

    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! {
        didSet { passwordValidationMessageLabelOutlet.text = "" }
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
    
    @IBOutlet weak var toSignupLabel: UILabel! {
        didSet { toSignupLabel.text = signupLabelText }
    }
    
    internal var signupButton: UIButton { return signupButtonOutlet }
    @IBOutlet weak var signupButtonOutlet: UIButton! {
        didSet { signupButton.setUnderlinedTitle(signupButtonTitle) }
    }
    
    internal var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton! {
        didSet { recoverPasswordButton.setUnderlinedTitle(recoverPasswordButtonTitle) }
    }
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var emailErrorsView: UIView!
    @IBOutlet weak var passwordErrorsView: UIView!

    
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
    
    internal var passwordVisible: Bool = false {
        didSet { passwordVisibleWasSet() }
    }
    
    internal func render() {
        emailTextFieldValid = true
        passwordTextFieldValid = true
        emailTextFieldSelected = false
        passwordTextFieldSelected = false
        logInButtonEnabled = false
        logInButtonPressed = false
        passwordVisible = false
        
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
                emailErrorsView.hidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                emailErrorsView.hidden = false
            }
            emailTextFieldViewOutlet.layer.borderColor = color
        } else {
            emailErrorsView.hidden = true
        }
    }
    
    
    private func emailTextFieldSelectedWasSet() {
        if emailTextFieldSelected {
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            emailErrorsView.hidden = true
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
                passwordErrorsView.hidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                passwordErrorsView.hidden = false
            }
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = color
        } else {
            passwordErrorsView.hidden = true
        }
    }
    
    
    private func passwordTextFieldSelectedWasSet() {
        if passwordTextFieldSelected {
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            passwordErrorsView.hidden = true
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
        emailErrorsView.hidden = true
        passwordErrorsView.hidden = true
    }
    
    private func passwordVisibleWasSet() {
        // Changing enabled property for the
        // font setting to take effect, which is
        // necessary for it not to shrink.
        passwordTextField.enabled = false
        passwordTextField.secureTextEntry = !passwordVisible
        passwordTextField.enabled = true
        passwordTextField.font = delegate.fontPalette.textfields
        passwordVisibilityButtonOutlet.setTitle(passwordVisibilityButtonTitle, forState: .Normal)
    }
    
}

public extension LoginViewType {
        
    public var emailText: String {
        return "login-view.email".frameworkLocalized
    }
    
    public var passwordText: String {
        return "login-view.password".frameworkLocalized
    }
    
    public var emailPlaceholderText: String {
        return "login-view.email-placeholder".frameworkLocalized
    }
    
    public var passwordPlaceholderText: String {
        return "login-view.password-placeholder".frameworkLocalized
    }
    
    public var logInButtonTitle: String {
        return "login-view.login-button-title".frameworkLocalized
    }
    
    public var signupLabelText: String {
        return "login-view.to-signup-label".frameworkLocalized
    }
    
    public var signupButtonTitle: String {
        return "login-view.signup-button-title".frameworkLocalized
    }

    private var passwordVisibilityButtonTitle: String {
        return ("text-visibility-button-title." + (passwordVisible ? "false" : "true")).frameworkLocalized
    }
    
    public var recoverPasswordButtonTitle: String {
        return "login-view.recover-password-button-title".frameworkLocalized
    }
    
}
