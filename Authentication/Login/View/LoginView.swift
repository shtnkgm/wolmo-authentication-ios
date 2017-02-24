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
    var loginProviderButtons: [UIView] { get }
    
}

public extension LoginViewType {
    
    var signupLabel: UILabel? { return .none }
    
    var recoverPasswordLabel: UILabel? { return .none }
    
}

/** Default login view. */
internal final class LoginView: UIView, LoginViewType, NibLoadable {
    
    // - Warning: This delegate must be set before calling the `render` function,
    //    if you want to use your own instead of default one.
    internal lazy var delegate: LoginViewDelegate = DefaultLoginViewDelegate() //swiftlint:disable:this weak_delegate

    internal var state: LoginViewState = (email: (selected: false, content: .initialEmpty),
                                          password: (selected: false, content: .initialEmpty),
                                          logInButton: (executing: false, enabled: false))
    
    internal let tapRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        addGestureRecognizer(tapRecognizer)
        tapRecognizer.reactive.stateChanged.observeValues { [unowned self] _ in
            self.endEditing(true)
        }
    }
    
    internal var logoImageView: UIImageView { return logoImageViewOutlet }
    @IBOutlet weak var logoImageViewOutlet: UIImageView!
    
// MARK: - Textfields and errors
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

// MARK: - login buttons
    internal var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton! {
        didSet {
            logInButtonOutlet.layer.cornerRadius = 6.0
            logInButtonOutlet.setTitle(logInButtonTitle, for: .normal)
        }
    }
    
    // - Warning: For these buttons to be seen, this var must be
    //      set before calling the `render` function.
    internal var loginProviderButtons: [UIView] = [] {
        didSet {
            if loginProviderButtons.isEmpty {
                loginAndLoginProvidersSeparator.isHidden = true
            }
            for providerButton in loginProviderButtons {
                loginProviderButtonsStackView.addArrangedSubview(providerButton)
                providerButton.layer.cornerRadius = 6.0
                providerButton.translatesAutoresizingMaskIntoConstraints = false
                providerButton.heightAnchor.constraint(equalTo: logInButton.heightAnchor).isActive = true
            }
        }
    }
    
// MARK: - Navigation buttons
    internal var signupLabel: UILabel? { return signupLabelOutlet }
    @IBOutlet weak var signupLabelOutlet: UILabel! {
        didSet { signupLabelOutlet.text = signupLabelText }
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

// MARK: - Container views
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
    
    @IBOutlet weak var loginAndLoginProvidersSeparator: UIView!
    @IBOutlet weak var loginProviderButtonsStackView: UIStackView!
    
// MARK: - LoginViewType setters
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

// MARK: - state functions
fileprivate extension LoginView {
    
    fileprivate func updateState(event: LoginViewEvent) {
        let newState = nextState(state: state, event: event)
        renderState(state: newState)
        state = newState
    }
    
    //swiftlint:disable:next function_body_length cyclomatic_complexity
    private func nextState(state: LoginViewState, event: LoginViewEvent) -> LoginViewState {
        switch event {
        case .emailSelected:
            let emailState = (selected: true, content: state.email.content)
            return (email: emailState, password: state.password, logInButton: state.logInButton)
        case .emailUnselected:
            let emailState = (selected: false, content: state.email.content)
            return (email: emailState, password: state.password, logInButton: state.logInButton)
        case .emailValid:
            let emailState = (selected: state.email.selected, content: TextFieldContentState.valid)
            return (email: emailState, password: state.password, logInButton: state.logInButton)
        case .emailInvalid:
            let emailState = (selected: state.email.selected, content: TextFieldContentState.invalid)
            return (email: emailState, password: state.password, logInButton: state.logInButton)
        case .passwordSelected:
            let passwordState = (selected: true, content: state.password.content)
            return (email: state.email, password: passwordState, logInButton: state.logInButton)
        case .passwordUnselected:
            let passwordState = (selected: false, content: state.password.content)
            return (email: state.email, password: passwordState, logInButton: state.logInButton)
        case .passwordValid:
            let passwordState = (selected: state.password.selected, content: TextFieldContentState.valid)
            return (email: state.email, password: passwordState, logInButton: state.logInButton)
        case .passwordInvalid:
            let passwordState = (selected: state.password.selected, content: TextFieldContentState.invalid)
            return (email: state.email, password: passwordState, logInButton: state.logInButton)
        case .logInButtonPressed:
            let logInButtonState = (executing: true, enabled: state.logInButton.enabled)
            return (email: state.email, password: state.password, logInButton: logInButtonState)
        case .logInButtonUnpressed:
            let logInButtonState = (executing: false, enabled: state.logInButton.enabled)
            return (email: state.email, password: state.password, logInButton: logInButtonState)
        case .logInButtonEnabled:
            let logInButtonState = (executing: state.logInButton.executing, enabled: true)
            return (email: state.email, password: state.password, logInButton: logInButtonState)
        case .logInButtonDisabled:
            let logInButtonState = (executing: state.logInButton.executing, enabled: false)
            return (email: state.email, password: state.password, logInButton: logInButtonState)
        }
    }
    
    private func renderState(state: LoginViewState) {
        renderEmailState(state: state.email)
        renderPasswordState(state: state.password)
        renderLogInButtonState(state: state.logInButton)
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
    
    private func renderLogInButtonState(state: ButtonState) {
        switch state {
        case (executing: true, enabled: true):
            logInButton.backgroundColor = delegate.colorPalette.mainButtonExecuted
        case (executing: true, enabled: false):
            logInButton.backgroundColor = delegate.colorPalette.mainButtonDisabled
        case (executing: false, enabled: false):
            logInButton.backgroundColor = delegate.colorPalette.mainButtonDisabled
        case (executing: false, enabled: true):
            logInButton.backgroundColor = delegate.colorPalette.mainButtonEnabled
        }
    }
    
}

// MARK: - setters reaction extension
fileprivate extension LoginView {
    
    fileprivate func emailTextFieldValidWasSet() {
        let event: LoginViewEvent = emailTextFieldValid ? .emailValid : .emailInvalid
        updateState(event: event)
    }
    
    fileprivate func emailTextFieldSelectedWasSet() {
        let event: LoginViewEvent = emailTextFieldSelected ? .emailSelected : .emailUnselected
        updateState(event: event)
    }
    
    fileprivate func passwordTextFieldValidWasSet() {
        let event: LoginViewEvent = passwordTextFieldValid ? .passwordValid : .passwordInvalid
        updateState(event: event)
    }
    
    fileprivate func passwordTextFieldSelectedWasSet() {
        let event: LoginViewEvent = passwordTextFieldSelected ? .passwordSelected : .passwordUnselected
        updateState(event: event)
    }
    
    fileprivate func logInButtonEnabledWasSet() {
        let event: LoginViewEvent = logInButtonEnabled ? .logInButtonEnabled : .logInButtonDisabled
        updateState(event: event)
    }
    
    fileprivate func logInButtonPressedWasSet() {
        let event: LoginViewEvent = logInButtonPressed ? .logInButtonPressed : .logInButtonUnpressed
        updateState(event: event)
    }
    
    fileprivate func passwordVisibleWasSet() {
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
