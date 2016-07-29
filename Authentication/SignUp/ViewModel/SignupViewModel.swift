//
//  SignupViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError
import Rex

/**
     Protocol for signup view models.
     They must handle validation and
     actions of all possible signup elements.
 */
public protocol SignupViewModelType {
    
    /** Name/Username field considerations: content and validation errors. */
    var name: MutableProperty<String> { get }
    var nameValidationErrors: AnyProperty<[String]> { get }
    
    /** Email field considerations: content and validation errors. */
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    /** Password field considerations: content, validation errors
     and password visibility. */
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    var passwordVisible: MutableProperty<Bool> { get }
    var togglePasswordVisibility: CocoaAction { get }
    
    /** Confirm Password field considerations: content, validation
     errors and password visibility. */
    var passwordConfirmation: MutableProperty<String> { get }
    var passwordConfirmationValidationErrors: AnyProperty<[String]> { get }
    var confirmationPasswordVisible: MutableProperty<Bool> { get }
    var toggleConfirmPasswordVisibility: CocoaAction { get }
    
    /** Sign Up action considerations: action, executing state and errors. */
    var signUpCocoaAction: CocoaAction { get }
    var signUpErrors: Signal<SessionServiceError, NoError> { get }
    var signUpExecuting: Signal<Bool, NoError> { get }
    
}

/**
     Default SignupViewModel responsible for validating entries to email and password fields
     and username and/or password confirmation fields if required. Therefore it's also 
     responsible for enabling sign up action, managing password visibility, reporting sign up
     events and communicating with the session service for executing the sign up.
 */
public final class SignupViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User>: SignupViewModelType {
    
    private let _sessionService: SessionService
    
    private let _credentialsAreValid: AndProperty
    
    public let name = MutableProperty("")
    public let email = MutableProperty("")
    public let password = MutableProperty("")
    public let passwordConfirmation = MutableProperty("")
    
    public let nameValidationErrors: AnyProperty<[String]>
    public let emailValidationErrors: AnyProperty<[String]>
    public let passwordValidationErrors: AnyProperty<[String]>
    public let passwordConfirmationValidationErrors: AnyProperty<[String]>
    
    public let passwordVisible = MutableProperty(false)
    public let confirmationPasswordVisible = MutableProperty(false)
    
    public var signUpCocoaAction: CocoaAction { return _signUp.unsafeCocoaAction }
    public var signUpErrors: Signal<SessionServiceError, NoError> { return _signUp.errors }
    public var signUpExecuting: Signal<Bool, NoError> { return _signUp.executing.signal }
    
    public var togglePasswordVisibility: CocoaAction { return _togglePasswordVisibility.unsafeCocoaAction }
    public var toggleConfirmPasswordVisibility: CocoaAction { return _toggleConfirmationPasswordVisibility.unsafeCocoaAction }
    
    private lazy var _signUp: Action<AnyObject, User, SessionServiceError> = self.initializeSignUpAction()
    
    private lazy var _togglePasswordVisibility: Action<AnyObject, Bool, NoError> = self.initializeTogglePasswordVisibilityAction()
    private lazy var _toggleConfirmationPasswordVisibility: Action<AnyObject, Bool, NoError> = self.initializeToggleConfirmationPasswordVisibilityAction()
    
    /**
         Initializes a signup view model which will communicate to the session service provided and
         will regulate the sign up with the validation criteria from the login credentials validator.
         
         - Parameters:
             - sessionService: session service to communicate with for sign up action.
             - credentialsValidator: signup credentials validator which encapsulates the criteria
             that the email, password and username fields must meet.
             - usernameEnabled: property indicating if this view model should take into account
             username validation.
             - passwordConfirmationEnabled: property indicating if this view model should take
             into account the password confirmation validation.
     
         - Warning: The `usernameEnabled` and `passwordConfirmationEnabled` properties should be
         consistent with the view that will be used.
     */
    internal init(sessionService: SessionService,
                  credentialsValidator: SignupCredentialsValidator = SignupCredentialsValidator(),
                  usernameEnabled: Bool = true,
                  passwordConfirmationEnabled: Bool = true) {
        _sessionService = sessionService
        
        let nameValidationResult = name.signal.map(credentialsValidator.nameValidator.validate)
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        let passwordConfirmValidationResult = combineLatest(password.signal, passwordConfirmation.signal)
            .map { $0 == $1 }.map(getPasswordConfirmValidationResultFromEquality)
        
        nameValidationErrors = AnyProperty(initialValue: [], signal: nameValidationResult.map { $0.errors })
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
        passwordConfirmationValidationErrors = AnyProperty(initialValue: [], signal: passwordConfirmValidationResult.map { $0.errors })
        
        var credentialsAreValid = AnyProperty<Bool>(initialValue: false, signal: emailValidationResult.map { $0.isValid })
            .and(AnyProperty<Bool>(initialValue: false, signal: passwordValidationResult.map { $0.isValid }))
        if usernameEnabled {
            credentialsAreValid = credentialsAreValid
                .and(AnyProperty<Bool>(initialValue: false, signal: nameValidationResult.map { $0.isValid }))
        }
        if passwordConfirmationEnabled {
            credentialsAreValid = credentialsAreValid
                .and(AnyProperty<Bool>(initialValue: false, signal:passwordConfirmValidationResult.map { $0.isValid }))
        }
        _credentialsAreValid = credentialsAreValid
    }
    
}

private extension SignupViewModel {
    
    private func initializeSignUpAction() -> Action<AnyObject, User, SessionServiceError> {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                return self._sessionService.signUp(self.name.value, email: email, password: self.password.value)
            } else {
                return SignalProducer(error: .InvalidSignUpCredentials(.None)).observeOn(UIScheduler())
            }
        }
    }
    
    private func initializeTogglePasswordVisibilityAction() -> Action<AnyObject, Bool, NoError> {
        return Action { [unowned self] _ in
            self.passwordVisible.value = !self.passwordVisible.value
            return SignalProducer(value: self.passwordVisible.value).observeOn(UIScheduler())
        }
    }
    
    private func initializeToggleConfirmationPasswordVisibilityAction() -> Action<AnyObject, Bool, NoError> {
        return Action { [unowned self] _ in
            self.confirmationPasswordVisible.value = !self.confirmationPasswordVisible.value
            return SignalProducer(value: self.confirmationPasswordVisible.value).observeOn(UIScheduler())
        }
    }
    
}

private func getPasswordConfirmValidationResultFromEquality(equals: Bool) -> ValidationResult {
    return equals ? .Valid : .invalid("signup-error.password-confirmation.invalid".frameworkLocalized)
}
