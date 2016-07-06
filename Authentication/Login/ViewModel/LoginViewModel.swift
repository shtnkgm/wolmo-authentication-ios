//
//  LoginViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

/**
    Protocol for login view models.
*/
public protocol LoginViewModelType {
    
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    var showPassword: MutableProperty<Bool> { get }
    
    var togglePasswordVisibilityCocoaAction: CocoaAction { get }
    var logInCocoaAction: CocoaAction { get }
    var logInErrors: Signal<SessionServiceError, NoError> { get }
    var logInExecuting: Signal<Bool, NoError> { get }
    
    var emailText: String { get }
    var passwordText: String { get }
    var emailPlaceholderText: String { get }
    var passwordPlaceholderText: String { get }
    var loginButtonTitle: String { get }
    var signupLabelText: String { get }
    var signupButtonTitle: String { get }
    var recoverPasswordButtonTitle: String { get }
    var passwordVisibilityButtonTitle: String { get }
    
}

/**
    Default LoginViewModel responsible for validating entries to email and password fields 
    and therefore enabling log in action, managing password visibility, reporting log in events
    and communicating with the session service for executing the log in.
*/
public final class LoginViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User> : LoginViewModelType {
    
    private let _credentialsAreValid: AnyProperty<Bool>
    private let _sessionService: SessionService
    
    public let email = MutableProperty("")
    public let emailValidationErrors: AnyProperty<[String]>
    
    public let password = MutableProperty("")
    public let passwordValidationErrors: AnyProperty<[String]>
    public let showPassword = MutableProperty(false)
    
    private lazy var _logIn: Action<AnyObject, User, SessionServiceError> = {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                let password = self.password.value
                return self._sessionService.logIn(email, password).observeOn(UIScheduler())
            } else {
                return SignalProducer(error: .InvalidLogInCredentials(.None)).observeOn(UIScheduler())
            }
        }
    }()
    public var logInCocoaAction: CocoaAction { return _logIn.unsafeCocoaAction }
    public var logInErrors: Signal<SessionServiceError, NoError> { return _logIn.errors }
    public var logInExecuting: Signal<Bool, NoError> { return _logIn.executing.signal }
    
    
    private lazy var _togglePasswordVisibility: Action<AnyObject, Bool, NoError> = {
        return Action { [unowned self] _ in
            self.showPassword.value = !self.showPassword.value
            return SignalProducer(value: self.showPassword.value).observeOn(UIScheduler())
        }
    }()
    public var togglePasswordVisibilityCocoaAction: CocoaAction { return _togglePasswordVisibility.unsafeCocoaAction }
    
    /**
        Initializes a login view model which will communicate to the session service provided and
        will regulate the log in with the validation criteria from the login credentials validator.
     
        - Parameters:
            - sessionService: session service to communicate with for log in action.
            - credentialsValidator: login credentials validator which encapsulates the criteria
            that the email and password fields must meet.
     
        - Returns: A valid login view model ready to use.
    */
    public init(sessionService: SessionService, credentialsValidator: LoginCredentialsValidator = LoginCredentialsValidator()) {
        _sessionService = sessionService
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        
        let credentialsValidationResults = combineLatest(
            emailValidationResult.map { $0.isValid },
            passwordValidationResult.map { $0.isValid })
        _credentialsAreValid = AnyProperty(
            initialValue: false,
            signal: credentialsValidationResults.map { $0 && $1 })
        
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
    }
    
}

public extension LoginViewModel {
    
    var emailText: String {
        return "login-view-model.email".localized
    }
    
    var passwordText: String {
        return "login-view-model.password".localized
    }
    
    var emailPlaceholderText: String {
        return "login-view-model.email-placeholder".localized
    }
    
    var passwordPlaceholderText: String {
        return "login-view-model.password-placeholder".localized
    }
    
    var loginButtonTitle: String {
        return "login-view-model.login-button-title".localized
    }
    
    var signupLabelText: String {
        return "login-view.to-signup-label".localized
    }
    
    var signupButtonTitle: String {
        return "login-view-model.signup-button-title".localized
    }
    
    var passwordVisibilityButtonTitle: String {
        return ("login-view-model.password-visibility-button-title." + (showPassword.value ? "false" : "true")).localized
    }
    
    var recoverPasswordButtonTitle: String {
        return "login-view-model.recover-password-button-title".localized
    }
    
}
