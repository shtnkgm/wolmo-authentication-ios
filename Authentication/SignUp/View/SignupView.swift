//
//  SignupViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Core


/**
     Represents the minimum required
     properties from a signup view
     for it to be compatible with
     the framework.
 */
public protocol SignupViewType: Renderable, SignupFormType {

    var titleLabel: UILabel { get }
    
    /* Navigation elements to other screens */
    var loginLabel: UILabel? { get }
    var loginButton: UIButton { get }
    
}

public extension SignupViewType {
    
    var loginLabel: UILabel? { return .None }
    
}

/** Default signup view. */
internal final class SignupView: UIView, SignupViewType, NibLoadable {
    
    internal lazy var delegate: SignupViewDelegate = DefaultSignupViewDelegate()
    
    internal var titleLabel: UILabel { return titleLabelOutlet }
    @IBOutlet weak var titleLabelOutlet: UILabel! {
        didSet { titleLabel.text = titleText }
    }
    
    
    
    internal var usernameTextField: UITextField? { return usernameTextFieldOutlet }
    @IBOutlet weak var usernameTextFieldOutlet: UITextField! {
        didSet { usernameTextFieldOutlet.placeholder = namePlaceholderText }
    }
    
    @IBOutlet weak var usernameTextFieldViewOutlet: UIView! {
        didSet {
            usernameTextFieldViewOutlet.layer.borderWidth = 1
            usernameTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var usernameValidationMessageLabel: UILabel? { return usernameValidationMessageLabelOutlet }
    @IBOutlet weak var usernameValidationMessageLabelOutlet: UILabel! {
        didSet { usernameValidationMessageLabelOutlet.text = " " }
    }
    
    @IBOutlet weak var usernameErrorsView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameHeightConstraint: NSLayoutConstraint!
    
    
    
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
    
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! {
        didSet { emailValidationMessageLabelOutlet.text = " " }
    }
    
    @IBOutlet weak var emailErrorsView: UIView!

    
    
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
    
    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! {
        didSet { passwordValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! {
        didSet { passwordVisibilityButtonOutlet.hidden = true }
    }
    
    @IBOutlet weak var passwordErrorsView: UIView!

    
    
    internal var passwordConfirmTextField: UITextField? { return passwordConfirmTextFieldOutlet }
    @IBOutlet weak var passwordConfirmTextFieldOutlet: UITextField! {
        didSet { passwordConfirmTextFieldOutlet.placeholder = confirmPasswordPlaceholderText }
    }
    @IBOutlet weak var pswdConfirmTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            pswdConfirmTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var passwordConfirmValidationMessageLabel: UILabel? { return pswdConfirmValidationMessageLabelOutlet }
    @IBOutlet weak var pswdConfirmValidationMessageLabelOutlet: UILabel! {
        didSet { pswdConfirmValidationMessageLabelOutlet.text = " " }
    }
    
    internal var passwordConfirmVisibilityButton: UIButton? { return passwordConfirmVisibilityButtonOutlet }
    @IBOutlet weak var passwordConfirmVisibilityButtonOutlet: UIButton! {
        didSet { passwordConfirmVisibilityButtonOutlet.hidden = true }
    }
    
    @IBOutlet weak var passwordConfirmationErrorsView: UIView!
    @IBOutlet weak var passwordConfirmationView: UIView!
    @IBOutlet weak var passwordConfirmationHeightConstraint: NSLayoutConstraint!
    
    
    internal var signUpButton: UIButton { return signUpButtonOutlet }
    @IBOutlet weak var signUpButtonOutlet: UIButton! {
        didSet {
            signUpButtonOutlet.layer.cornerRadius = 6.0
            signUpButtonOutlet.setTitle(signUpButtonTitle, forState: .Normal)
        }
    }
    
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
    
    internal var loginButton: UIButton { return loginButtonOutlet }
    @IBOutlet weak var loginButtonOutlet: UIButton! {
        didSet { loginButtonOutlet.setTitle(loginButtonTitle, forState: .Normal) }
    }
    
    internal var usernameTextFieldValid = false { didSet { usernameTextFieldValidWasSet() } }
    internal var usernameTextFieldSelected = false { didSet { usernameTextFieldSelectedWasSet() } }
    
    internal var emailTextFieldValid = false { didSet { emailTextFieldValidWasSet() } }
    internal var emailTextFieldSelected = false { didSet { emailTextFieldSelectedWasSet() } }
    
    internal var passwordTextFieldValid = false { didSet { passwordTextFieldValidWasSet() } }
    internal var passwordTextFieldSelected = false { didSet { passwordTextFieldSelectedWasSet() } }
    internal var passwordVisible = false { didSet { passwordVisibleWasSet() } }
    
    internal var passwordConfirmationTextFieldValid = false { didSet { passwordConfirmationTextFieldValidWasSet() } }
    internal var passwordConfirmationTextFieldSelected = false { didSet { passwordConfirmationTextFieldSelectedWasSet() } }
    internal var confirmationPasswordVisible = false { didSet { confirmationPasswordVisibleWasSet() } }
    
    internal var signUpButtonEnabled = false { didSet { signUpButtonEnabledWasSet() } }
    internal var signUpButtonPressed = false { didSet { signUpButtonPressedWasSet() } }
    
    
    internal func hideUsernameElements() {
        usernameHeightConstraint.active = false
        usernameView.hidden = true
    }
    
    
    internal func hidePasswordConfirmElements() {
        passwordConfirmationHeightConstraint.active = false
        passwordConfirmationView.hidden = true
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
        
        passwordVisible = false
        confirmationPasswordVisible = false
        
        delegate.configureView(self)
    }
    
}

private extension SignupView {
    
    private func usernameTextFieldValidWasSet() {
        if !usernameTextFieldSelected {
            let color: CGColor
            if usernameTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.CGColor
                usernameErrorsView.hidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                usernameErrorsView.hidden = false
            }
            usernameTextFieldViewOutlet.layer.borderColor = color
        } else {
            usernameErrorsView.hidden = true
        }
    }
    
    private func usernameTextFieldSelectedWasSet() {
        if usernameTextFieldSelected {
            usernameTextFieldOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            usernameErrorsView.hidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = usernameTextFieldValid
            usernameTextFieldValid = valid
        }
    }
    
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
            // To trigger the Valid's didSet.
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
            // To trigger the Valid's didSet.
            let valid = passwordTextFieldValid
            passwordTextFieldValid = valid
        }
    }
    
    private func passwordVisibleWasSet() {
        // Changing enabled property for the font setting to take effect, which is necessary for it not to shrink.
        passwordTextField.enabled = false
        passwordTextField.secureTextEntry = !passwordVisible
        passwordTextField.enabled = true
        passwordTextField.font = delegate.fontPalette.textfields
        passwordVisibilityButtonOutlet.setTitle(passwordVisibilityButtonTitle, forState: .Normal)
    }
    
    private func passwordConfirmationTextFieldValidWasSet() {
        if !passwordConfirmationTextFieldSelected {
            let color: CGColor
            if passwordConfirmationTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.CGColor
                passwordConfirmationErrorsView.hidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.CGColor
                passwordConfirmationErrorsView.hidden = false
            }
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = color
        } else {
            passwordConfirmationErrorsView.hidden = true
        }
    }
    
    private func passwordConfirmationTextFieldSelectedWasSet() {
        if passwordConfirmationTextFieldSelected {
            passwordConfirmTextFieldOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.CGColor
            passwordConfirmationErrorsView.hidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = passwordConfirmationTextFieldValid
            passwordConfirmationTextFieldValid = valid
        }
    }
    
    private func confirmationPasswordVisibleWasSet() {
        // Changing enabled property for the font setting to take effect, which is necessary for it not to shrink.
        passwordConfirmTextField?.enabled = false
        passwordConfirmTextField?.secureTextEntry = !confirmationPasswordVisible
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
        usernameErrorsView?.hidden = true
        emailErrorsView.hidden = true
        passwordErrorsView.hidden = true
        passwordConfirmationErrorsView?.hidden = true
    }
    
}

public extension SignupViewType {

    public var titleText: String { return "signup-view.title".frameworkLocalized }
    
    public var nameText: String { return "signup-view.name".frameworkLocalized }
    
    public var emailText: String { return "signup-view.email".frameworkLocalized }
    
    public var passwordText: String { return "signup-view.password".frameworkLocalized }
    
    public var confirmPasswordText: String { return "signup-view.confirm-password".frameworkLocalized }
    
    public var namePlaceholderText: String { return "signup-view.name-placeholder".frameworkLocalized}
    
    public var emailPlaceholderText: String { return "signup-view.email-placeholder".frameworkLocalized }
    
    public var passwordPlaceholderText: String { return "signup-view.password-placeholder".frameworkLocalized }
    
    public var confirmPasswordPlaceholderText: String { return "signup-view.confirm-password-placeholder".frameworkLocalized }
    
    public var passwordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (passwordVisible ? "false" : "true")).frameworkLocalized }
    
    public var confirmPasswordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (confirmationPasswordVisible ? "false" : "true")).frameworkLocalized }
    
    public var termsAndServicesLabelText: String { return "signup-view.terms-and-services.label-text".frameworkLocalized }
    
    public var termsAndServicesButtonTitle: String { return "signup-view.terms-and-services.button-title".frameworkLocalized }
    
    public var signUpButtonTitle: String { return "signup-view.signup-button-title".frameworkLocalized }
    
    public var loginLabelText: String { return "signup-view.login.label-text".frameworkLocalized }
    
    public var loginButtonTitle: String { return "signup-view.login.button-title".frameworkLocalized }
    
}
