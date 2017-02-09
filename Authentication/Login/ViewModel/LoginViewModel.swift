//
//  LoginViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

/**
    Protocol for login view models.
    They must handle validation and
    actions of all possible login elements.
*/
public protocol LoginViewModelType {
    
    /** Email field considerations: content and validation errors. */
    var email: MutableProperty<String> { get }
    var emailValidationErrors: Property<[String]> { get }
    
    /** Password field considerations: content, validation errors
       and password visibility. */
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: Property<[String]> { get }
    var passwordVisible: MutableProperty<Bool> { get }
    var togglePasswordVisibility: CocoaAction<UIButton> { get }
    
    /** Log In action considerations: action, executing state and errors. */
    var logInCocoaAction: CocoaAction<UIButton> { get }
    var logInErrors: Signal<SessionServiceError, NoError> { get }
    var logInExecuting: Signal<Bool, NoError> { get }
    var logInSuccessful: Signal<(), NoError> { get }
    var logInProviderUserSignal: Signal<LoginProviderUserType, NoError> { get }
    
}

/**
    Default LoginViewModel responsible for validating entries to email and password fields 
    and therefore enabling log in action, managing password visibility, reporting log in events
    and communicating with the session service for executing the log in.
*/
public final class LoginViewModel<User, SessionService: SessionServiceType> : LoginViewModelType where SessionService.User == User {
    
    fileprivate let _credentialsAreValid: Property<Bool>
    fileprivate let _sessionService: SessionService
    
    public let email = MutableProperty("")
    public let emailValidationErrors: Property<[String]>
    
    public let password = MutableProperty("")
    public let passwordValidationErrors: Property<[String]>
    public let passwordVisible = MutableProperty(false)
    
    public var logInCocoaAction: CocoaAction<UIButton> { return CocoaAction(_logIn) }
    public var logInErrors: Signal<SessionServiceError, NoError> { return _logIn.errors }
    public var logInExecuting: Signal<Bool, NoError> { return _logIn.isExecuting.signal }
    public private(set) lazy var logInSuccessful: Signal<(), NoError> = self.initializeLogInSuccesfulSignal()
    public let logInProviderUserSignal: Signal<LoginProviderUserType, NoError>
    
    public var togglePasswordVisibility: CocoaAction<UIButton> { return CocoaAction(_togglePasswordVisibility) }
    
    fileprivate lazy var _logIn: Action<(), User, SessionServiceError> = self.initializeLogInAction()
    
    private lazy var _togglePasswordVisibility: Action<(), Bool, NoError> = self.initializeTogglePasswordVisibilityAction()
    
    /**
        Initializes a login view model which will communicate to the session service provided and
        will regulate the log in with the validation criteria from the login credentials validator.
     
        - Parameters:
            - sessionService: session service to communicate with for log in action.
            - credentialsValidator: login credentials validator which encapsulates the criteria
            that the email and password fields must meet.
    */
    internal init(sessionService: SessionService,
                  credentialsValidator: LoginCredentialsValidator = LoginCredentialsValidator(),
                  providerUserSignals: [Signal<LoginProviderUserType, NoError>] = []) {
        _sessionService = sessionService
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        
        let credentialsValidationResults = Signal.combineLatest(emailValidationResult.map { $0.isValid },
                                                                passwordValidationResult.map { $0.isValid })
        _credentialsAreValid = Property(initial: false, then: credentialsValidationResults.map { $0 && $1 })
        
        emailValidationErrors = Property(initial: [], then: emailValidationResult.map { $0.errors })
        passwordValidationErrors = Property(initial: [], then: passwordValidationResult.map { $0.errors })
        logInProviderUserSignal = Signal.merge(providerUserSignals)
    }
    
}

fileprivate extension LoginViewModel {
    
    fileprivate func initializeLogInSuccesfulSignal() -> Signal<Void, NoError> {
        let loggedInWithProviderUserSignal = self.logInProviderUserSignal.flatMap(.latest) { [unowned self] loginProviderUserType -> SignalProducer<User, SessionServiceError> in
            return self._sessionService.logIn(withUser: loginProviderUserType)
        }
        
        let successfullyLoggedInWithProviderUserSignal = loggedInWithProviderUserSignal
            .flatMapError { _ in return SignalProducer<User, NoError>.empty }
            .map { _ in () }
        let successfullyLoggedInWithMailSignal = self._logIn.values.map { _ in () }
        return Signal.merge([successfullyLoggedInWithProviderUserSignal, successfullyLoggedInWithMailSignal])
    }
    
    fileprivate func initializeLogInAction() -> Action<(), User, SessionServiceError> {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                let password = self.password.value
                return self._sessionService.logIn(withEmail: email, password: password).observe(on: UIScheduler())
            } else {
                return SignalProducer(error: .invalidLogInCredentials(.none)).observe(on: UIScheduler())
            }
        }
    }
    
    fileprivate func initializeTogglePasswordVisibilityAction() -> Action<(), Bool, NoError> {
        return Action { [unowned self] _ in
            self.passwordVisible.value = !self.passwordVisible.value
            return SignalProducer(value: self.passwordVisible.value).observe(on: UIScheduler())
        }
    }
}
