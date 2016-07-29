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
    They must handle validation and
    actions of all possible login elements.
*/
public protocol LoginViewModelType {
    
    /** Email field considerations: content and validation errors. */
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    /** Password field considerations: content, validation errors
       and password visibility. */
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    var passwordVisible: MutableProperty<Bool> { get }
    var togglePasswordVisibility: CocoaAction { get }
    
    /** Log In action considerations: action, executing state and errors. */
    var logInCocoaAction: CocoaAction { get }
    var logInErrors: Signal<SessionServiceError, NoError> { get }
    var logInExecuting: Signal<Bool, NoError> { get }
    
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
    public let passwordVisible = MutableProperty(false)
    
    public var logInCocoaAction: CocoaAction { return _logIn.unsafeCocoaAction }
    public var logInErrors: Signal<SessionServiceError, NoError> { return _logIn.errors }
    public var logInExecuting: Signal<Bool, NoError> { return _logIn.executing.signal }
    
    public var togglePasswordVisibility: CocoaAction { return _togglePasswordVisibility.unsafeCocoaAction }
    
    private lazy var _logIn: Action<AnyObject, User, SessionServiceError> = self.initializeLogInAction()
    
    private lazy var _togglePasswordVisibility: Action<AnyObject, Bool, NoError> = self.initializeTogglePasswordVisibilityAction()
    
    /**
        Initializes a login view model which will communicate to the session service provided and
        will regulate the log in with the validation criteria from the login credentials validator.
     
        - Parameters:
            - sessionService: session service to communicate with for log in action.
            - credentialsValidator: login credentials validator which encapsulates the criteria
            that the email and password fields must meet.
    */
    internal init(sessionService: SessionService, credentialsValidator: LoginCredentialsValidator = LoginCredentialsValidator()) {
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

private extension LoginViewModel {
    
    private func initializeLogInAction() -> Action<AnyObject, User, SessionServiceError> {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                let password = self.password.value
                return self._sessionService.logIn(email, password: password).observeOn(UIScheduler())
            } else {
                return SignalProducer(error: .InvalidLogInCredentials(.None)).observeOn(UIScheduler())
            }
        }
    }
    
    private func initializeTogglePasswordVisibilityAction() -> Action<AnyObject, Bool, NoError> {
        return Action { [unowned self] _ in
            self.passwordVisible.value = !self.passwordVisible.value
            return SignalProducer(value: self.passwordVisible.value).observeOn(UIScheduler())
        }
    }
}
