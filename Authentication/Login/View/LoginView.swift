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
    
    var signupLabel: UILabel? { return .none }
    
    var recoverPasswordLabel: UILabel? { return .none }
    
}

/** Default login view. */
internal final class LoginView: UIView, LoginViewType, NibLoadable {
    
    internal lazy var delegate: LoginViewDelegate = DefaultLoginViewDelegate() //swiftlint:disable:this weak_delegate
    
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
        didSet { passwordVisibilityButtonOutlet.isHidden = true }
    }
    
    internal var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton! {
        didSet {
            logInButtonOutlet.layer.cornerRadius = 6.0
            logInButtonOutlet.setTitle(logInButtonTitle, for: .normal)
        }
    }
    
    @IBOutlet weak var toSignupLabel: UILabel! {
        didSet { toSignupLabel.text = signupLabelText }
    }
    
    internal var signupButton: UIButton { return signupButtonOutlet }
    @IBOutlet weak var signupButtonOutlet: UIButton! {
        didSet { signupButton.setUnderlined(title: signupButtonTitle) }
    }
    
    internal var recoverPasswordButton: UIButton { return recoverPasswordButtonOutlet }
    @IBOutlet weak var recoverPasswordButtonOutlet: UIButton! {
        didSet {
            recoverPasswordButtonOutlet.setUnderlined(title: recoverPasswordButtonTitle)
            recoverPasswordButtonOutlet.isHidden = true
        }
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
        delegate.configureLoginView(self)
    }
    
}

private extension LoginView {
    
    func emailTextFieldValidWasSet() {
        if !emailTextFieldSelected {
            let color: CGColor
            if emailTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.cgColor
                emailErrorsView.isHidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.cgColor
                emailErrorsView.isHidden = false
            }
            emailTextFieldViewOutlet.layer.borderColor = color
        } else {
            emailErrorsView.isHidden = true
        }
    }
    
    func emailTextFieldSelectedWasSet() {
        if emailTextFieldSelected {
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            emailErrorsView.isHidden = true
        } else {
            let valid = emailTextFieldValid
            emailTextFieldValid = valid
        }
    }
    
    func passwordTextFieldValidWasSet() {
        if !passwordTextFieldSelected {
            let color: CGColor
            if passwordTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.cgColor
                passwordErrorsView.isHidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.cgColor
                passwordErrorsView.isHidden = false
            }
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = color
        } else {
            passwordErrorsView.isHidden = true
        }
    }
    
    func passwordTextFieldSelectedWasSet() {
        if passwordTextFieldSelected {
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            passwordErrorsView.isHidden = true
        } else {
            let valid = passwordTextFieldValid
            passwordTextFieldValid = valid
        }
    }
    
    func logInButtonEnabledWasSet() {
        let colorPalette = delegate.colorPalette
        let color = logInButtonEnabled ? colorPalette.mainButtonEnabled : colorPalette.mainButtonDisabled
        logInButton.backgroundColor = color
    }
    
    func logInButtonPressedWasSet() {
        let colorPalette = delegate.colorPalette
        let color = logInButtonPressed ? colorPalette.mainButtonExecuted : colorPalette.mainButtonEnabled
        logInButton.backgroundColor = color
        emailErrorsView.isHidden = true
        passwordErrorsView.isHidden = true
    }
    
    func passwordVisibleWasSet() {
        // Changing enabled property for the
        // font setting to take effect, which is
        // necessary for it not to shrink.
        passwordTextField.isEnabled = false
        passwordTextField.isSecureTextEntry = !passwordVisible
        passwordTextField.isEnabled = true
        passwordTextField.font = delegate.fontPalette.textfields
        passwordVisibilityButtonOutlet.setTitle(passwordVisibilityButtonTitle, for: .normal)
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

    fileprivate var passwordVisibilityButtonTitle: String {
        return ("text-visibility-button-title." + (passwordVisible ? "false" : "true")).frameworkLocalized
    }
    
    public var recoverPasswordButtonTitle: String {
        return "login-view.recover-password-button-title".frameworkLocalized
    }
    
}
