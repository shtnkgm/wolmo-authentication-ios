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
    var loginProviderButtons: [UIView] { get }
    
}

public extension SignupViewType {
    
    var loginLabel: UILabel? { return .none }
    
}

/** Default signup view. */
internal final class SignupView: UIView, SignupViewType, NibLoadable {
    
    internal var delegate: SignupViewDelegate! //swiftlint:disable:this weak_delegate
    
    internal var titleLabel: UILabel { return titleLabelOutlet }
    @IBOutlet weak var titleLabelOutlet: UILabel! { didSet { titleLabel.text = titleText } }
    
    internal var usernameTextField: UITextField? { return usernameTextFieldOutlet }
    @IBOutlet weak var usernameTextFieldOutlet: UITextField! { didSet { usernameTextFieldOutlet.placeholder = usernamePlaceholderText } }
    
    @IBOutlet weak var usernameTextFieldViewOutlet: UIView! {
        didSet {
            usernameTextFieldViewOutlet.layer.borderWidth = 1
            usernameTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var usernameValidationMessageLabel: UILabel? { return usernameValidationMessageLabelOutlet }
    @IBOutlet weak var usernameValidationMessageLabelOutlet: UILabel! { didSet { usernameValidationMessageLabelOutlet.text = " " } }

    @IBOutlet weak var usernameErrorsView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameHeightConstraint: NSLayoutConstraint!
    
    internal var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField! { didSet { emailTextFieldOutlet.placeholder = emailPlaceholderText } }
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! { didSet { emailValidationMessageLabelOutlet.text = " " } }
    
    @IBOutlet weak var emailErrorsView: UIView!
    
    internal var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! { didSet { passwordTextFieldOutlet.placeholder = passwordPlaceholderText } }
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! { didSet { passwordValidationMessageLabelOutlet.text = " " } }
    
    internal var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! { didSet { passwordVisibilityButtonOutlet.isHidden = true } }
    
    @IBOutlet weak var passwordErrorsView: UIView!

    internal var passwordConfirmTextField: UITextField? { return passwordConfirmTextFieldOutlet }
    @IBOutlet weak var passwordConfirmTextFieldOutlet: UITextField! { didSet { passwordConfirmTextFieldOutlet.placeholder = confirmPasswordPlaceholderText } }
    @IBOutlet weak var pswdConfirmTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            pswdConfirmTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    
    internal var passwordConfirmValidationMessageLabel: UILabel? { return pswdConfirmValidationMessageLabelOutlet }
    @IBOutlet weak var pswdConfirmValidationMessageLabelOutlet: UILabel! { didSet { pswdConfirmValidationMessageLabelOutlet.text = " " } }
    
    internal var passwordConfirmVisibilityButton: UIButton? { return passwordConfirmVisibilityButtonOutlet }
    @IBOutlet weak var passwordConfirmVisibilityButtonOutlet: UIButton! { didSet { passwordConfirmVisibilityButtonOutlet.isHidden = true } }
    
    @IBOutlet weak var passwordConfirmationErrorsView: UIView!
    @IBOutlet weak var passwordConfirmationView: UIView!
    @IBOutlet weak var passwordConfirmationHeightConstraint: NSLayoutConstraint!
    
    internal var signUpButton: UIButton { return signUpButtonOutlet }
    @IBOutlet weak var signUpButtonOutlet: UIButton! {
        didSet {
            signUpButtonOutlet.layer.cornerRadius = 6.0
            signUpButtonOutlet.setTitle(signUpButtonTitle, for: .normal)
        }
    }
    
    internal var termsAndServicesTextView: UITextView { return termsAndServicesTextViewOutlet }
    @IBOutlet weak var termsAndServicesTextViewOutlet: UITextView!
    
    internal var loginLabel: UILabel? { return loginLabelOutlet }
    @IBOutlet weak var loginLabelOutlet: UILabel! { didSet { loginLabelOutlet.text = loginLabelText } }
    
    internal var loginButton: UIButton { return loginButtonOutlet }
    @IBOutlet weak var loginButtonOutlet: UIButton! { didSet { loginButtonOutlet.setUnderlined(title: loginButtonTitle) } }
    
    @IBOutlet weak var signUpOrView: UIView!
    @IBOutlet weak var loginProviderButtonsStackView: UIStackView!
    
    internal var loginProviderButtons: [UIView] = [] {
        didSet {
            if loginProviderButtons.isEmpty {
                signUpOrView.removeFromSuperview()
            }
            for providerButton in loginProviderButtons {
                loginProviderButtonsStackView.addArrangedSubview(providerButton)
                providerButton.heightAnchor.constraint(equalTo: signUpButton.heightAnchor).isActive = true
            }
        }
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
    internal var passwordConfirmationVisible = false { didSet { confirmationPasswordVisibleWasSet() } }
    
    internal var signUpButtonEnabled = false { didSet { signUpButtonEnabledWasSet() } }
    internal var signUpButtonPressed = false { didSet { signUpButtonPressedWasSet() } }
    
    internal func hideUsernameElements() {
        usernameHeightConstraint.isActive = false
        usernameView.isHidden = true
    }
    
    internal func hidePasswordConfirmElements() {
        passwordConfirmationHeightConstraint.isActive = false
        passwordConfirmationView.isHidden = true
    }
    
    internal func setTermsAndServicesText(withURL url: URL) {
        let textWithLinks = NSMutableAttributedString(string: termsAndServicesText)
        let termsString = termsAndServicesLinkText
        let termsURLRange = NSString(string: termsAndServicesText).range(of: termsString)
        textWithLinks.addAttribute(NSLinkAttributeName, value: url, range: termsURLRange)
        
        termsAndServicesTextView.attributedText = textWithLinks
        termsAndServicesTextView.linkTextAttributes = [NSForegroundColorAttributeName: delegate.colorPalette.links,
                                                       NSUnderlineColorAttributeName: delegate.colorPalette.links,
                                                       NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        termsAndServicesTextView.textAlignment = .center
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
        passwordConfirmationVisible = false
        
        delegate.configureSignupView(self)
    }
    
}

fileprivate extension SignupView {
    
    fileprivate func usernameTextFieldValidWasSet() {
        if !usernameTextFieldSelected {
            let color: CGColor
            if usernameTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.cgColor
                usernameErrorsView.isHidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.cgColor
                usernameErrorsView.isHidden = false
            }
            usernameTextFieldViewOutlet.layer.borderColor = color
        } else {
            usernameErrorsView.isHidden = true
        }
    }
    
    fileprivate func usernameTextFieldSelectedWasSet() {
        if usernameTextFieldSelected {
            usernameTextFieldOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            usernameErrorsView.isHidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = usernameTextFieldValid
            usernameTextFieldValid = valid
        }
    }
    
    fileprivate func emailTextFieldValidWasSet() {
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
    
    fileprivate func emailTextFieldSelectedWasSet() {
        if emailTextFieldSelected {
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            emailErrorsView.isHidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = emailTextFieldValid
            emailTextFieldValid = valid
        }
    }
    
    fileprivate func passwordTextFieldValidWasSet() {
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
    
    fileprivate func passwordTextFieldSelectedWasSet() {
        if passwordTextFieldSelected {
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            passwordErrorsView.isHidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = passwordTextFieldValid
            passwordTextFieldValid = valid
        }
    }
    
    fileprivate func passwordVisibleWasSet() {
        toggleVisibility(ofTextField: passwordTextFieldOutlet, visible: passwordVisible,
                         visibilityButton: passwordVisibilityButtonOutlet, visibilityTitle: passwordVisibilityButtonTitle)
    }
    
    fileprivate func passwordConfirmationTextFieldValidWasSet() {
        if !passwordConfirmationTextFieldSelected {
            let color: CGColor
            if passwordConfirmationTextFieldValid {
                color = delegate.colorPalette.textfieldsNormal.cgColor
                passwordConfirmationErrorsView.isHidden = true
            } else {
                color = delegate.colorPalette.textfieldsError.cgColor
                passwordConfirmationErrorsView.isHidden = false
            }
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = color
        } else {
            passwordConfirmationErrorsView.isHidden = true
        }
    }
    
    fileprivate func passwordConfirmationTextFieldSelectedWasSet() {
        if passwordConfirmationTextFieldSelected {
            passwordConfirmTextFieldOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            passwordConfirmationErrorsView.isHidden = true
        } else {
            // To trigger the Valid's didSet.
            let valid = passwordConfirmationTextFieldValid
            passwordConfirmationTextFieldValid = valid
        }
    }
    
    fileprivate func confirmationPasswordVisibleWasSet() {
        toggleVisibility(ofTextField: passwordConfirmTextFieldOutlet, visible: passwordConfirmationVisible,
                         visibilityButton: passwordConfirmVisibilityButtonOutlet, visibilityTitle: confirmPasswordVisibilityButtonTitle)
    }
    
    private func toggleVisibility(ofTextField textField: UITextField, visible: Bool, visibilityButton: UIButton, visibilityTitle: String) {
        // Changing enabled property for the font setting to take effect, which is necessary for it not to shrink.
        textField.isEnabled = false
        textField.isSecureTextEntry = !visible
        textField.isEnabled = true
        textField.font = delegate.fontPalette.textfields
        visibilityButton.setTitle(visibilityTitle, for: UIControlState())
    }
    
    fileprivate func signUpButtonEnabledWasSet() {
        let colorPalette = delegate.colorPalette
        let color = signUpButtonEnabled ? colorPalette.mainButtonEnabled : colorPalette.mainButtonDisabled
        signUpButton.backgroundColor = color
    }
    
    fileprivate func signUpButtonPressedWasSet() {
        let colorPalette = delegate.colorPalette
        let color = signUpButtonPressed ? colorPalette.mainButtonExecuted : colorPalette.mainButtonEnabled
        signUpButton.backgroundColor = color
        usernameErrorsView?.isHidden = true
        emailErrorsView.isHidden = true
        passwordErrorsView.isHidden = true
        passwordConfirmationErrorsView?.isHidden = true
    }
    
}

public extension SignupViewType {

    public var titleText: String { return "signup-view.title".frameworkLocalized }
    
    public var usernameText: String { return "signup-view.username".frameworkLocalized }
    
    public var emailText: String { return "signup-view.email".frameworkLocalized }
    
    public var passwordText: String { return "signup-view.password".frameworkLocalized }
    
    public var confirmPasswordText: String { return "signup-view.confirm-password".frameworkLocalized }
    
    public var usernamePlaceholderText: String { return "signup-view.username-placeholder".frameworkLocalized}
    
    public var emailPlaceholderText: String { return "signup-view.email-placeholder".frameworkLocalized }
    
    public var passwordPlaceholderText: String { return "signup-view.password-placeholder".frameworkLocalized }
    
    public var confirmPasswordPlaceholderText: String { return "signup-view.confirm-password-placeholder".frameworkLocalized }
    
    public var passwordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (passwordVisible ? "false" : "true")).frameworkLocalized }
    
    public var confirmPasswordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (passwordConfirmationVisible ? "false" : "true")).frameworkLocalized }
    
    public var termsAndServicesText: String { return "signup-view.terms-and-services.text".frameworkLocalized }
    
    public var termsAndServicesLinkText: String { return "signup-view.terms-and-services.link-text".frameworkLocalized }
    
    public var signUpButtonTitle: String { return "signup-view.signup-button-title".frameworkLocalized }
    
    public var loginLabelText: String { return "signup-view.login.label-text".frameworkLocalized }
    
    public var loginButtonTitle: String { return "signup-view.login.button-title".frameworkLocalized }
    
}
