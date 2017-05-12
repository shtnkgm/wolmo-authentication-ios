//
//  SignupViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import Core

/**
     Protocol for signup view models.
     They must handle validation and
     actions of all possible signup elements.
 */
public protocol SignupViewModelType {
    
    /** Username field considerations: content and validation errors. */
    var username: MutableProperty<String> { get }
    var usernameValidationErrors: Property<[String]> { get }
    
    /** Email field considerations: content and validation errors. */
    var email: MutableProperty<String> { get }
    var emailValidationErrors: Property<[String]> { get }
    
    /** Password field considerations: content, validation errors
     and password visibility. */
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: Property<[String]> { get }
    var passwordVisible: MutableProperty<Bool> { get }
    var togglePasswordVisibility: CocoaAction<UIButton> { get }
    
    /** Confirm Password field considerations: content, validation
     errors and password visibility. */
    var passwordConfirmation: MutableProperty<String> { get }
    var passwordConfirmationValidationErrors: Property<[String]> { get }
    var passwordConfirmationVisible: MutableProperty<Bool> { get }
    var togglePasswordConfirmVisibility: CocoaAction<UIButton> { get }
    
    /** Sign Up action considerations: action, executing state and errors.
        Or login executing state, values and errors if using providers. */
    var signUpCocoaAction: CocoaAction<UIButton> { get }
    var signUpErrors: Signal<SessionServiceError, NoError> { get }
    var signUpExecuting: Signal<Bool, NoError> { get }
    var signUpSuccessful: Signal<(), NoError> { get }
    
    var usernameEnabled: Bool { get }
    var passwordConfirmationEnabled: Bool { get }
    
    /** Functions for the view model to start or stop ignoring providers'events.
        This is needed for when one view is pushed on top of the other,
        and so both view models exists at the same time. */
    func bindProviders()
    func unbindProviders()
    
}

/**
     Default SignupViewModel responsible for validating entries to email and password fields
     and username and/or password confirmation fields if required. Therefore it's also 
     responsible for enabling sign up action, managing password visibility, reporting sign up
     events and communicating with the session service for executing the sign up.
 */
public final class SignupViewModel<User, SessionService: SessionServiceType>: SignupViewModelType where SessionService.User == User {
    
    public let username = MutableProperty("")
    public let email = MutableProperty("")
    public let password = MutableProperty("")
    public let passwordConfirmation = MutableProperty("")
    
    public let usernameValidationErrors: Property<[String]>
    public let emailValidationErrors: Property<[String]>
    public let passwordValidationErrors: Property<[String]>
    public let passwordConfirmationValidationErrors: Property<[String]>
    
    public let passwordVisible = MutableProperty(false)
    public let passwordConfirmationVisible = MutableProperty(false)
    
    public var signUpCocoaAction: CocoaAction<UIButton> { return CocoaAction(_signUp) }
    public private(set) lazy var signUpErrors: Signal<SessionServiceError, NoError> = self.initializeErrorsSignal()
    public private(set) lazy var signUpExecuting: Signal<Bool, NoError> = self.initializeExecutingSignal()
    public private(set) lazy var signUpSuccessful: Signal<(), NoError> = self.initializeSuccessfulSignal()
    
    public var togglePasswordVisibility: CocoaAction<UIButton> { return CocoaAction(_togglePasswordVisibility) }
    public var togglePasswordConfirmVisibility: CocoaAction<UIButton> { return CocoaAction(_togglePasswordConfirmVisibility) }
    
    public let usernameEnabled: Bool
    public let passwordConfirmationEnabled: Bool
    
    fileprivate let _sessionService: SessionService
    fileprivate let _credentialsAreValid: Property<Bool>
    
    private lazy var _togglePasswordVisibility: Action<(), Bool, NoError> = self.initializeTogglePasswordVisibilityAction()
    private lazy var _togglePasswordConfirmVisibility: Action<(), Bool, NoError> = self.initializeTogglePasswordConfirmationVisibilityAction()
    
    fileprivate lazy var _signUp: Action<(), User, SessionServiceError> = self.initializeSignUpAction()
    fileprivate let _logInProvidersUserSignal: Signal<LoginProviderUserType, NoError>
    fileprivate let _logInProvidersErrorSignal: Signal<LoginProviderErrorType, NoError>
    fileprivate lazy var _logInProvidersFinalUserSignal: Signal<Result<User, SessionServiceError>, NoError> = self.initializeLogInUserSignal()
    
    // The providers executing signal can only track the login to the session service,
    //  after the login with the login provider was successful.
    // This wouldn't affect the UX since the providers are supposed to present a view
    //  for logging in and close it after it succeeded or failed.
    fileprivate let _loginProvidersExecutingSignal: Signal<Bool, NoError>
    fileprivate let _loginProvidersExecutingObserver: Observer<Bool, NoError>
    
    fileprivate var _ignoreProviders: Bool = true
    
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
    //swiftlint:disable:next function_body_length
    internal init(sessionService: SessionService,
                  credentialsValidator: SignupCredentialsValidator = SignupCredentialsValidator(),
                  usernameEnabled: Bool = true,
                  passwordConfirmationEnabled: Bool = true,
                  providerSignals: [(Signal<LoginProviderUserType, NoError>, Signal<LoginProviderErrorType, NoError>)] = []) { //swiftlint:disable:this large_tuple
        _sessionService = sessionService
        
        let usernameValidationResult = username.signal.map(credentialsValidator.usernameValidator.validate)
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        let passwordConfirmValidationResult = Signal.combineLatest(password.signal, passwordConfirmation.signal).map(==).map(getPasswordConfirmValidationResultFromEquality)
        
        usernameValidationErrors = Property(initial: [], then: usernameValidationResult.map { $0.errors })
        emailValidationErrors = Property(initial: [], then: emailValidationResult.map { $0.errors })
        passwordValidationErrors = Property(initial: [], then: passwordValidationResult.map { $0.errors })
        passwordConfirmationValidationErrors = Property(initial: [], then: passwordConfirmValidationResult.map { $0.errors })
        
        var credentialsAreValid = Property<Bool>(initial: false, then: emailValidationResult.map { $0.isValid })
            .combineLatest(with: Property<Bool>(initial: false, then: passwordValidationResult.map { $0.isValid })).map { $0 && $1 }
        credentialsAreValid = usernameEnabled ? credentialsAreValid.combineLatest(with: Property<Bool>(initial: false, then: usernameValidationResult
                .map { $0.isValid })).map { $0 && $1 } : credentialsAreValid
        credentialsAreValid = passwordConfirmationEnabled ? credentialsAreValid.combineLatest(with: Property<Bool>(initial: false, then:passwordConfirmValidationResult
                .map { $0.isValid })).map { $0 && $1 } : credentialsAreValid
        _credentialsAreValid = credentialsAreValid
        self.usernameEnabled = usernameEnabled
        self.passwordConfirmationEnabled = passwordConfirmationEnabled
        
        _logInProvidersUserSignal = Signal.merge(providerSignals.map { $0.0 })
        _logInProvidersErrorSignal = Signal.merge(providerSignals.map { $0.1 })
        
        (_loginProvidersExecutingSignal, _loginProvidersExecutingObserver) = Signal.pipe()
    }
    
    public func bindProviders() {
        _ignoreProviders = false
    }
    
    public func unbindProviders() {
        _ignoreProviders = true
    }
    
}

fileprivate extension SignupViewModel {
    
    fileprivate func initializeErrorsSignal() -> Signal<SessionServiceError, NoError> {
        let signupWithMailErrors = _signUp.errors
        let loginWithProvidersErrors = _logInProvidersFinalUserSignal.filterErrors()
        return Signal.merge([signupWithMailErrors, loginWithProvidersErrors])
    }
    
    fileprivate func initializeExecutingSignal() -> Signal<Bool, NoError> {
        return Signal.merge([_signUp.isExecuting.signal, _loginProvidersExecutingSignal])
    }
    
    fileprivate func initializeSuccessfulSignal() -> Signal<(), NoError> {
        let successfullyLoggedInWithProvidersSignal = _logInProvidersFinalUserSignal.filterValues().map { _ in () }
        let successfullySignedUpInWithMailSignal = _signUp.values.map { _ in () }
        return Signal.merge([successfullyLoggedInWithProvidersSignal, successfullySignedUpInWithMailSignal])
    }
    
    fileprivate func initializeLogInUserSignal() -> Signal<Result<User, SessionServiceError>, NoError> {
        let usersSignal = _logInProvidersUserSignal.flatMap(.latest) {
            // Weak self because the original signal will continue to exists
            // independently of this view models existance (or deallocation).
            // And so if this is the second view presented, self won't exists but the signal yes.
            [weak self] loginProviderUserType -> SignalProducer<Result<User, SessionServiceError>, NoError> in  //swiftlint:disable:this closure_parameter_position
            if let existingSelf = self, !existingSelf._ignoreProviders {
                return existingSelf.sessionServiceLogInWithExecuting(user: loginProviderUserType)
            } else {
                return SignalProducer.empty
            }
        }
        let errorsSignal = _logInProvidersErrorSignal
            .flatMap(.latest) { [weak self] value -> SignalProducer<LoginProviderErrorType, NoError> in
                if let existingSelf = self, !existingSelf._ignoreProviders {
                    return SignalProducer(value: value)
                } else {
                    return SignalProducer.empty
                }
            }.map { Result<User, SessionServiceError>.failure($0.sessionServiceError) }
        return Signal.merge([usersSignal, errorsSignal])
    }
    
    private func sessionServiceLogInWithExecuting(user: LoginProviderUserType) -> SignalProducer<Result<User, SessionServiceError>, NoError> {
        return _sessionService.logIn(withUser: user)
            .on(started: { [unowned self] in
                    self._loginProvidersExecutingObserver.send(value: true)
                }, failed: { [unowned self] _ in
                    self._loginProvidersExecutingObserver.send(value: false)
                }, completed: { [unowned self] in
                    self._loginProvidersExecutingObserver.send(value: false)
                }, interrupted: { [unowned self] in
                    self._loginProvidersExecutingObserver.send(value: false)
                }, terminated: { [unowned self] in
                    self._loginProvidersExecutingObserver.send(value: false)
            }).toResultSignalProducer()
    }
    
    fileprivate func initializeSignUpAction() -> Action<(), User, SessionServiceError> {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                let username: String? = self.usernameEnabled ? self.username.value : .none
                return self._sessionService.signUp(withUsername: username, email: email, password: self.password.value)
            } else {
                // It will never enter here, since sign up action is only enabled when email is a valid email.
                return SignalProducer(error: .invalidSignUpCredentials(.none)).observe(on: UIScheduler())
            }
        }
    }
    
    fileprivate func initializeTogglePasswordVisibilityAction() -> Action<(), Bool, NoError> {
        return Action { [unowned self] _ in
            self.passwordVisible.value = !self.passwordVisible.value
            return SignalProducer(value: self.passwordVisible.value).observe(on: UIScheduler())
        }
    }
    
    fileprivate func initializeTogglePasswordConfirmationVisibilityAction() -> Action<(), Bool, NoError> {
        return Action { [unowned self] _ in
            self.passwordConfirmationVisible.value = !self.passwordConfirmationVisible.value
            return SignalProducer(value: self.passwordConfirmationVisible.value).observe(on: UIScheduler())
        }
    }
    
}

private func getPasswordConfirmValidationResultFromEquality(_ equals: Bool) -> ValidationResult {
    return equals ? .valid : .invalid(errors: ["signup-error.password-confirmation.invalid".frameworkLocalized])
}
