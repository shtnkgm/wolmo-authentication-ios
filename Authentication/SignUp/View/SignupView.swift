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
    
    public var loginLabel: UILabel? { return .none }

    public var loginProviderButtons: [UIView] { return [] }
    
}

/** Default signup view. */
internal final class SignupView: UIView, SignupViewType, NibLoadable {
    
    // - Warning: This delegate must be set before calling the `render` function
    //    or setting any `SignupViewType` setter, or the app will crash.
    internal var delegate: SignupViewDelegate! //swiftlint:disable:this weak_delegate
    
    internal var state: SignupViewState = (email: (selected: false, content: .initialEmpty),
                                           password: (selected: false, content: .initialEmpty),
                                           username: (selected: false, content: .initialEmpty),
                                           confirmPassword: (selected: false, content: .initialEmpty),
                                           signUpButton: (executing: false, enabled: false))
    
    internal let tapRecognizer = UITapGestureRecognizer()
    
    internal override func awakeFromNib() {
        addGestureRecognizer(tapRecognizer)
        tapRecognizer.reactive.stateChanged.observeValues { [unowned self] _ in
            self.endEditing(true)
        }
    }
    
    internal var titleLabel: UILabel { return titleLabelOutlet }
    @IBOutlet weak var titleLabelOutlet: UILabel! { didSet { titleLabel.text = titleText } }
    
// MARK: - Textfields and errors
    internal var usernameTextField: UITextField? { return usernameTextFieldOutlet }
    @IBOutlet weak var usernameTextFieldOutlet: UITextField! { didSet { usernameTextFieldOutlet.placeholder = usernamePlaceholderText } }
    internal var usernameValidationMessageLabel: UILabel? { return usernameValidationMessageLabelOutlet }
    @IBOutlet weak var usernameValidationMessageLabelOutlet: UILabel! { didSet { usernameValidationMessageLabelOutlet.text = " " } }
    
    internal var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField! { didSet { emailTextFieldOutlet.placeholder = emailPlaceholderText } }
    internal var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel! { didSet { emailValidationMessageLabelOutlet.text = " " } }
    
    internal var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! { didSet { passwordTextFieldOutlet.placeholder = passwordPlaceholderText } }
    internal var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel! { didSet { passwordValidationMessageLabelOutlet.text = " " } }
    internal var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton! { didSet { passwordVisibilityButtonOutlet.isHidden = true } }

    internal var passwordConfirmTextField: UITextField? { return passwordConfirmTextFieldOutlet }
    @IBOutlet weak var passwordConfirmTextFieldOutlet: UITextField! { didSet { passwordConfirmTextFieldOutlet.placeholder = confirmPasswordPlaceholderText } }
    internal var passwordConfirmValidationMessageLabel: UILabel? { return pswdConfirmValidationMessageLabelOutlet }
    @IBOutlet weak var pswdConfirmValidationMessageLabelOutlet: UILabel! { didSet { pswdConfirmValidationMessageLabelOutlet.text = " " } }
    internal var passwordConfirmVisibilityButton: UIButton? { return passwordConfirmVisibilityButtonOutlet }
    @IBOutlet weak var passwordConfirmVisibilityButtonOutlet: UIButton! { didSet { passwordConfirmVisibilityButtonOutlet.isHidden = true } }
    
// MARK: - signup buttons
    internal var signUpButton: UIButton { return signUpButtonOutlet }
    @IBOutlet weak var signUpButtonOutlet: UIButton! {
        didSet {
            signUpButtonOutlet.layer.cornerRadius = 6.0
            signUpButtonOutlet.setTitle(signUpButtonTitle, for: .normal)
        }
    }
    
    // - Warning: For these buttons to be seen, this var must be
    //      set before calling the `render` function.
    internal var loginProviderButtons: [UIView] = []
    
// MARK: - Navigation buttons
    internal var termsAndServicesTextView: UITextView { return termsAndServicesTextViewOutlet }
    @IBOutlet weak var termsAndServicesTextViewOutlet: UITextView!
    
    internal var loginLabel: UILabel? { return loginLabelOutlet }
    @IBOutlet weak var loginLabelOutlet: UILabel! { didSet { loginLabelOutlet.text = loginLabelText } }
    
    internal var loginButton: UIButton { return loginButtonOutlet }
    @IBOutlet weak var loginButtonOutlet: UIButton! { didSet { loginButtonOutlet.setUnderlined(title: loginButtonTitle) } }

// MARK: - Container views
    @IBOutlet weak var usernameTextFieldViewOutlet: UIView! {
        didSet {
            usernameTextFieldViewOutlet.layer.borderWidth = 1
            usernameTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var usernameErrorsView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextFieldViewOutlet: UIView! {
        didSet {
            emailTextFieldViewOutlet.layer.borderWidth = 1
            emailTextFieldViewOutlet.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var emailErrorsView: UIView!
    
    @IBOutlet weak var passwordTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            passwordTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            passwordTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var passwordErrorsView: UIView!
    
    @IBOutlet weak var pswdConfirmTextFieldAndButtonViewOutlet: UIView! {
        didSet {
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderWidth = 1
            pswdConfirmTextFieldAndButtonViewOutlet.layer.cornerRadius = 6.0
        }
    }
    @IBOutlet weak var passwordConfirmationErrorsView: UIView!
    @IBOutlet weak var passwordConfirmationView: UIView!
    @IBOutlet weak var passwordConfirmationHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupAndProvidersSeparator: UIView! {
        didSet {
            signupAndProvidersSeparator.isHidden = true
        }
    }
    @IBOutlet weak var loginProviderButtonsStackView: UIStackView!
    
// MARK: - SignupViewType setters
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
        textWithLinks.addAttribute(NSAttributedStringKey.link, value: url, range: termsURLRange)
        
        termsAndServicesTextView.attributedText = textWithLinks
        termsAndServicesTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: delegate.colorPalette.links,
                                                       NSAttributedStringKey.underlineColor.rawValue: delegate.colorPalette.links,
                                                       NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue]
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
        
        if delegate.showLoginProviders {
            configureLoginProviders()
        }
        delegate.configureSignupView(self)
        
        configureUI()
    }
    
}

// MARK: - signup providers configuration extension
fileprivate extension SignupView {
    
    fileprivate func configureLoginProviders() {
        signupAndProvidersSeparator.isHidden = false
        for providerButton in loginProviderButtons {
            loginProviderButtonsStackView.addArrangedSubview(providerButton)
            providerButton.layer.cornerRadius = 6.0
            providerButton.translatesAutoresizingMaskIntoConstraints = false
            providerButton.heightAnchor.constraint(equalTo: signUpButton.heightAnchor).isActive = true
        }
    }
    
}

// MARK: - state functions
fileprivate extension SignupView {
    
    fileprivate func updateState(event: SignupViewEvent) {
        let newState = nextState(state: state, event: event)
        renderState(state: newState)
        state = newState
    }
    
    //swiftlint:disable:next function_body_length cyclomatic_complexity
    private func nextState(state: SignupViewState, event: SignupViewEvent) -> SignupViewState {
        switch event {
        case .emailSelected:
            let emailState = (selected: true, content: state.email.content)
            return (email: emailState, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .emailUnselected:
            let emailState = (selected: false, content: state.email.content)
            return (email: emailState, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .emailValid:
            let emailState = (selected: state.email.selected, content: TextFieldContentState.valid)
            return (email: emailState, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .emailInvalid:
            let emailState = (selected: state.email.selected, content: TextFieldContentState.invalid)
            return (email: emailState, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .passwordSelected:
            let passwordState = (selected: true, content: state.password.content)
            return (email: state.email, password: passwordState, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .passwordUnselected:
            let passwordState = (selected: false, content: state.password.content)
            return (email: state.email, password: passwordState, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .passwordValid:
            let passwordState = (selected: state.password.selected, content: TextFieldContentState.valid)
            return (email: state.email, password: passwordState, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .passwordInvalid:
            let passwordState = (selected: state.password.selected, content: TextFieldContentState.invalid)
            return (email: state.email, password: passwordState, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .usernameSelected:
            let usernameState = (selected: true, content: state.username.content)
            return (email: state.email, password: state.password, username: usernameState,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .usernameUnselected:
            let usernameState = (selected: false, content: state.username.content)
            return (email: state.email, password: state.password, username: usernameState,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .usernameValid:
            let usernameState = (selected: state.username.selected, content: TextFieldContentState.valid)
            return (email: state.email, password: state.password, username: usernameState,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .usernameInvalid:
            let usernameState = (selected: state.username.selected, content: TextFieldContentState.invalid)
            return (email: state.email, password: state.password, username: usernameState,
                    confirmPassword: state.confirmPassword, signUpButton: state.signUpButton)
        case .confirmPasswordSelected:
            let confirmPasswordState = (selected: true, content: state.confirmPassword.content)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: confirmPasswordState, signUpButton: state.signUpButton)
        case .confirmPasswordUnselected:
            let confirmPasswordState = (selected: false, content: state.confirmPassword.content)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: confirmPasswordState, signUpButton: state.signUpButton)
        case .confirmPasswordValid:
            let confirmPasswordState = (selected: state.confirmPassword.selected, content: TextFieldContentState.valid)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: confirmPasswordState, signUpButton: state.signUpButton)
        case .confirmPasswordInvalid:
            let confirmPasswordState = (selected: state.confirmPassword.selected, content: TextFieldContentState.invalid)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: confirmPasswordState, signUpButton: state.signUpButton)
        case .signUpButtonPressed:
            let signUpButtonState = (executing: true, enabled: state.signUpButton.enabled)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: signUpButtonState)
        case .signUpButtonUnpressed:
            let signUpButtonState = (executing: false, enabled: state.signUpButton.enabled)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: signUpButtonState)
        case .signUpButtonEnabled:
            let signUpButtonState = (executing: state.signUpButton.executing, enabled: true)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: signUpButtonState)
        case .signUpButtonDisabled:
            let signUpButtonState = (executing: state.signUpButton.executing, enabled: false)
            return (email: state.email, password: state.password, username: state.username,
                    confirmPassword: state.confirmPassword, signUpButton: signUpButtonState)
        }
    }
    
    private func renderState(state: SignupViewState) {
        renderEmailState(state: state.email)
        renderPasswordState(state: state.password)
        renderUsernameState(state: state.username)
        renderConfirmPasswordState(state: state.confirmPassword)
        renderSignUpButtonState(state: state.signUpButton)
    }
    
    private func renderEmailState(state: TextFieldState) {
        switch state {
        case (selected: true, _):
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            emailErrorsView.isHidden = true
        case (selected: false, .initialEmpty):
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            emailErrorsView.isHidden = true
        case (selected: false, .valid):
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            emailErrorsView.isHidden = true
        case (selected: false, .invalid):
            emailTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsError.cgColor
            emailErrorsView.isHidden = false
        }
    }
    
    private func renderPasswordState(state: TextFieldState) {
        switch state {
        case (selected: true, _):
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            passwordErrorsView.isHidden = true
        case (selected: false, .initialEmpty):
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            passwordErrorsView.isHidden = true
        case (selected: false, .valid):
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            passwordErrorsView.isHidden = true
        case (selected: false, .invalid):
            passwordTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsError.cgColor
            passwordErrorsView.isHidden = false
        }
    }
    
    private func renderUsernameState(state: TextFieldState) {
        switch state {
        case (selected: true, _):
            usernameTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            usernameErrorsView.isHidden = true
        case (selected: false, .initialEmpty):
            usernameTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            usernameErrorsView.isHidden = true
        case (selected: false, .valid):
            usernameTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            usernameErrorsView.isHidden = true
        case (selected: false, .invalid):
            usernameTextFieldViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsError.cgColor
            usernameErrorsView.isHidden = false
        }
    }
    
    private func renderConfirmPasswordState(state: TextFieldState) {
        switch state {
        case (selected: true, _):
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsSelected.cgColor
            passwordConfirmationErrorsView.isHidden = true
        case (selected: false, .initialEmpty):
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            passwordConfirmationErrorsView.isHidden = true
        case (selected: false, .valid):
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsNormal.cgColor
            passwordConfirmationErrorsView.isHidden = true
        case (selected: false, .invalid):
            pswdConfirmTextFieldAndButtonViewOutlet.layer.borderColor = delegate.colorPalette.textfieldsError.cgColor
            passwordConfirmationErrorsView.isHidden = false
        }
    }
    
    private func renderSignUpButtonState(state: ButtonState) {
        switch state {
        case (executing: true, enabled: true):
            signUpButton.backgroundColor = delegate.colorPalette.mainButtonExecuted
        case (executing: true, enabled: false):
            signUpButton.backgroundColor = delegate.colorPalette.mainButtonDisabled
        case (executing: false, enabled: false):
            signUpButton.backgroundColor = delegate.colorPalette.mainButtonDisabled
        case (executing: false, enabled: true):
            signUpButton.backgroundColor = delegate.colorPalette.mainButtonEnabled
        }
    }
    
}

// MARK: - setters reaction extension
fileprivate extension SignupView {
    
    fileprivate func usernameTextFieldValidWasSet() {
        let event: SignupViewEvent = usernameTextFieldValid ? .usernameValid : .usernameInvalid
        updateState(event: event)
    }
    
    fileprivate func usernameTextFieldSelectedWasSet() {
        let event: SignupViewEvent = usernameTextFieldSelected ? .usernameSelected : .usernameUnselected
        updateState(event: event)
    }
    
    fileprivate func emailTextFieldValidWasSet() {
        let event: SignupViewEvent = emailTextFieldValid ? .emailValid : .emailInvalid
        updateState(event: event)
    }
    
    fileprivate func emailTextFieldSelectedWasSet() {
        let event: SignupViewEvent = emailTextFieldSelected ? .emailSelected : .emailUnselected
        updateState(event: event)
    }
    
    fileprivate func passwordTextFieldValidWasSet() {
        let event: SignupViewEvent = passwordTextFieldValid ? .passwordValid : .passwordInvalid
        updateState(event: event)
    }
    
    fileprivate func passwordTextFieldSelectedWasSet() {
        let event: SignupViewEvent = passwordTextFieldSelected ? .passwordSelected : .passwordUnselected
        updateState(event: event)
    }
    
    fileprivate func passwordVisibleWasSet() {
        toggleVisibility(ofTextField: passwordTextFieldOutlet, visible: passwordVisible,
                         visibilityButton: passwordVisibilityButtonOutlet, visibilityTitle: passwordVisibilityButtonTitle)
    }
    
    fileprivate func passwordConfirmationTextFieldValidWasSet() {
        let event: SignupViewEvent = passwordConfirmationTextFieldValid ? .confirmPasswordValid : .confirmPasswordInvalid
        updateState(event: event)
    }
    
    fileprivate func passwordConfirmationTextFieldSelectedWasSet() {
        let event: SignupViewEvent = passwordConfirmationTextFieldSelected ? .confirmPasswordSelected : .confirmPasswordUnselected
        updateState(event: event)
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
        let event: SignupViewEvent = signUpButtonEnabled ? .signUpButtonEnabled : .signUpButtonDisabled
        updateState(event: event)
    }
    
    fileprivate func signUpButtonPressedWasSet() {
        let event: SignupViewEvent = signUpButtonPressed ? .signUpButtonPressed : .signUpButtonUnpressed
        updateState(event: event)
    }
    
    fileprivate func configureUI() {
        usernameTextFieldViewOutlet.backgroundColor = delegate.colorPalette.textfieldBackground
        passwordTextFieldAndButtonViewOutlet.backgroundColor = delegate.colorPalette.textfieldBackground
        emailTextFieldViewOutlet.backgroundColor = delegate.colorPalette.textfieldBackground
        pswdConfirmTextFieldAndButtonViewOutlet.backgroundColor = delegate.colorPalette.textfieldBackground
        
        let placeholderColor = delegate.colorPalette.textfieldPlaceholderColor
        usernameTextFieldOutlet.attributedPlaceholder =
            NSAttributedString(string: usernamePlaceholderText, attributes: [ NSAttributedStringKey.foregroundColor: placeholderColor])
        emailTextFieldOutlet.attributedPlaceholder =
            NSAttributedString(string: emailPlaceholderText, attributes: [ NSAttributedStringKey.foregroundColor: placeholderColor])
        passwordTextFieldOutlet.attributedPlaceholder =
            NSAttributedString(string: passwordPlaceholderText, attributes: [ NSAttributedStringKey.foregroundColor: placeholderColor])
        passwordConfirmTextFieldOutlet.attributedPlaceholder =
            NSAttributedString(string: confirmPasswordPlaceholderText, attributes: [ NSAttributedStringKey.foregroundColor: placeholderColor])
    }
    
}
