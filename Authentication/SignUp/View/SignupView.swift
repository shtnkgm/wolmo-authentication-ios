//
//  SignupViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

public protocol SignupViewType: Renderable, SignupFormType {

    var titleLabel: UILabel { get }
    
    var loginLabel: UILabel? { get }
    var loginButton: UIButton? { get }
    
}

internal final class SignupView: UIView, SignupViewType, NibLoadable {
    
    internal lazy var delegate: SignupViewDelegate = DefaultSignupViewDelegate()
    
    internal var titleLabel: UILabel { return titleLabelOutlet }
    @IBOutlet weak var titleLabelOutlet: UILabel! {
        didSet { titleLabel.text = titleText }
    }

    internal var usernameLabel: UILabel? { return .None }
    internal var usernameTextField: UITextField? { return .None }
    internal var usernameValidationMessageLabel: UILabel? { return .None }
    var usernameErrorsHeightConstraint: NSLayoutConstraint?
    
    internal var emailLabel: UILabel? { return .None }
    
    internal var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField! {
        didSet { emailTextFieldOutlet.placeholder = emailPlaceholderText }
    }
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }

    @IBOutlet var emailErrorsHeightConstraint: NSLayoutConstraint!  // not weak
    
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet { emailValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordLabel: UILabel? { return .None }

    internal var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! {
        didSet { passwordTextFieldOutlet.placeholder = passwordPlaceholderText }
    }
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet var passwordErrorsHeightConstraint: NSLayoutConstraint!   // not weak
    
    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! {
        didSet { passwordValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! {
        didSet { passwordVisibilityButtonOutlet.hidden = true }
    }

    internal var passwordConfirmLabel: UILabel? { return .None }
    internal var passwordConfirmTextField: UITextField? { return .None }
    internal var passwordConfirmValidationMessageLabel: UILabel? { return .None }
    internal var passwordConfirmVisibilityButton: UIButton? { return .None }
    var passwordConfirmErrorsHeightConstraint: NSLayoutConstraint?
    
    internal var signUpButton: UIButton { return signUpButtonOutlet }
    @IBOutlet weak var signUpButtonOutlet: UIButton! {
        didSet {
            signUpButtonOutlet.layer.cornerRadius = 6.0
            signUpButtonOutlet.setTitle(signUpButtonTitle, forState: .Normal)
        }
    }
    internal var signUpErrorLabel: UILabel? { return .None }
    
    internal var termsAndServicesLabel: UILabel? { return termsAndServicesLabelOutlet }
    @IBOutlet weak var termsAndServicesLabelOutlet: UILabel! {
        didSet { termsAndServicesLabelOutlet.text = termsAndServicesLabelText }
    }
    internal var termsAndServicesButton: UIButton { return termsAndServicesButtonOutlet }
    @IBOutlet weak var termsAndServicesButtonOutlet: UIButton! {
        didSet { termsAndServicesButtonOutlet.setTitle(termsAndServicesButtonTitle, forState: .Normal) }
    }
    
    internal var loginLabel: UILabel? { return loginLabelOutlet }
    @IBOutlet weak var loginLabelOutlet: UILabel! {
        didSet { loginLabelOutlet.text = loginLabelText }
    }
    
    internal var loginButton: UIButton? { return loginButtonOutlet }
    @IBOutlet weak var loginButtonOutlet: UIButton! {
        didSet { loginButtonOutlet.setTitle(loginButtonTitle, forState: .Normal) }
    }
    
    internal var usernameTextFieldValid: Bool = false {
        didSet { usernameTextFieldValidWasSet() }
    }
    internal var usernameTextFieldSelected: Bool = false {
        didSet { usernameTextFieldSelectedWasSet() }
    }
    
    internal var emailTextFieldValid: Bool = false {
        didSet { emailTextFieldValidWasSet() }
    }
    internal var emailTextFieldSelected: Bool = false {
        didSet { emailTextFieldSelectedWasSet() }
    }
    
    internal var passwordTextFieldValid: Bool = false {
        didSet { passwordTextFieldValidWasSet() }
    }
    internal var passwordTextFieldSelected: Bool = false {
        didSet { passwordTextFieldSelectedWasSet() }
    }
    
    internal var showPassword: Bool = false {
        didSet { showPasswordWasSet() }
    }
    
    internal var passwordConfirmationTextFieldValid: Bool = false {
        didSet { passwordConfirmationTextFieldValidWasSet() }
    }
    internal var passwordConfirmationTextFieldSelected: Bool = false {
        didSet { passwordConfirmationTextFieldSelectedWasSet() }
    }
    
    internal var showConfirmationPassword: Bool = false {
        didSet { showConfirmationPasswordWasSet() }
    }
    
    internal var signUpButtonEnabled: Bool = false {
        didSet { signUpButtonEnabledWasSet() }
    }
    internal var signUpButtonPressed: Bool = false {
        didSet { signUpButtonPressedWasSet() }
    }
    
    internal func render() {
        usernameTextFieldValid = true
        emailTextFieldValid = true
        passwordTextFieldValid = true
        passwordConfirmationTextFieldValid = true
        
        usernameTextFieldSelected = false
        emailTextFieldSelected = false
        passwordTextFieldSelected = false
        passwordConfirmationTextFieldSelected = false
        
        signUpButtonEnabled = false
        signUpButtonPressed = false
        
        showPassword = false
        showConfirmationPassword = false
        
        delegate.configureView(self)
    }
    
}

private extension SignupView {
    
    private func usernameTextFieldValidWasSet() {
        if !usernameTextFieldSelected {
            let color: CGColor
            if usernameTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.CGColor
                usernameErrorsHeightConstraint?.constant = 0
                usernameErrorsHeightConstraint?.active = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                usernameErrorsHeightConstraint?.active = false
            }
            usernameTextField?.layer.borderColor = color
        } else {
            usernameErrorsHeightConstraint?.constant = 0
            usernameErrorsHeightConstraint?.active = true
        }
    }
    
    private func usernameTextFieldSelectedWasSet() {
        if usernameTextFieldSelected {
            usernameTextField?.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            usernameErrorsHeightConstraint?.constant = 0
            usernameErrorsHeightConstraint?.active = true
        } else {
            let valid = usernameTextFieldValid
            usernameTextFieldValid = valid
        }
    }
    
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
    
    private func passwordConfirmationTextFieldValidWasSet() {
        if !passwordConfirmationTextFieldSelected {
            let color: CGColor
            if passwordConfirmationTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.CGColor
                passwordConfirmErrorsHeightConstraint?.constant = 0
                passwordConfirmErrorsHeightConstraint?.active = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                passwordConfirmErrorsHeightConstraint?.active = false
            }
            passwordConfirmTextField?.layer.borderColor = color
        } else {
            passwordConfirmErrorsHeightConstraint?.constant = 0
            passwordConfirmErrorsHeightConstraint?.active = true
        }
    }
    
    private func passwordConfirmationTextFieldSelectedWasSet() {
        if passwordConfirmationTextFieldSelected {
            passwordConfirmTextField?.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            passwordConfirmErrorsHeightConstraint?.constant = 0
            passwordConfirmErrorsHeightConstraint?.active = true
        } else {
            let valid = passwordConfirmationTextFieldValid
            passwordConfirmationTextFieldValid = valid
        }
    }
    
    private func showConfirmationPasswordWasSet() {
        // Changing enabled property for the
        // font setting to take effect, which is
        // necessary for it not to shrink.
        passwordConfirmTextField?.enabled = false
        passwordConfirmTextField?.secureTextEntry = !showPassword
        passwordConfirmTextField?.enabled = true
        passwordConfirmTextField?.font = delegate.fontPalette.textfields
        passwordConfirmVisibilityButton?.setTitle(confirmPasswordVisibilityButtonTitle, forState: .Normal)
    }
    
    private func signUpButtonEnabledWasSet() {
        let colorPalette = delegate.colorPalette
        let color = signUpButtonEnabled ? colorPalette.mainButtonEnabled : colorPalette.mainButtonDisabled
        signUpButton.backgroundColor = color
    }
    
    private func signUpButtonPressedWasSet() {
        let colorPalette = delegate.colorPalette
        let color = signUpButtonPressed ? colorPalette.mainButtonExecuted : colorPalette.mainButtonEnabled
        signUpButton.backgroundColor = color
        usernameErrorsHeightConstraint?.constant = 0
        usernameErrorsHeightConstraint?.active = true
        emailErrorsHeightConstraint.constant = 0
        emailErrorsHeightConstraint.active = true
        passwordErrorsHeightConstraint.constant = 0
        passwordErrorsHeightConstraint.active = true
        passwordConfirmErrorsHeightConstraint?.constant = 0
        passwordConfirmErrorsHeightConstraint?.active = true
    }
    
}

public extension SignupViewType {
    
    public var titleText: String {
        return "signup-view.title".localized
    }
    
    public var nameText: String {
        return "signup-view.name".localized
    }
    
    public var emailText: String {
        return "signup-view.email".localized
    }
    
    public var passwordText: String {
        return "signup-view.password".localized
    }
    
    public var confirmPasswordText: String {
        return "signup-view.confirm-password".localized
    }
    
    public var namePlaceholderText: String {
        return "signup-view.name-placeholder".localized
    }
    
    public var emailPlaceholderText: String {
        return "signup-view.email-placeholder".localized
    }
    
    public var passwordPlaceholderText: String {
        return "signup-view.password-placeholder".localized
    }
    
    public var confirmPasswordPlaceholderText: String {
        return "signup-view.confirm-password-placeholder".localized
    }
    
    public var passwordVisibilityButtonTitle: String {
        return ("text-visibility-button-title." + (showPassword ? "false" : "true")).localized
    }
    
    public var confirmPasswordVisibilityButtonTitle: String {
        return ("text-visibility-button-title." + (showConfirmationPassword ? "false" : "true")).localized
    }
    
    public var termsAndServicesLabelText: String {
        return "signup-view.terms-and-services.label-text".localized
    }
    
    public var termsAndServicesButtonTitle: String {
        return "signup-view.terms-and-services.button-title".localized
    }
    
    public var signUpButtonTitle: String {
        return "signup-view.signup-button-title".localized
    }
    
    public var loginLabelText: String {
        return "signup-view.login.label-text".localized
    }
    
    public var loginButtonTitle: String {
        return "signup-view.login.button-title".localized
    }
    
}
