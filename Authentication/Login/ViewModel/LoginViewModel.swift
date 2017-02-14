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
import Result

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
    
    /** This action is for the login button to handle login 
       through completed information in the login screen
       (email, pasword, etc). */
    var logInCocoaAction: CocoaAction<UIButton> { get }
    /** This Signal must take into account any login triggered,
       even the ones from LoginProviders. */
    var logInExecuting: Signal<Bool, NoError> { get }
    /** This Signal must take into account any login triggered,
       even the ones from LoginProviders. */
    var logInSuccessful: Signal<(), NoError> { get }
    /** This Signal must take into account any login error risen,
       even the ones from LoginProviders. */
    var logInErrors: Signal<SessionServiceError, NoError> { get }
    
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
    public private(set) lazy var logInErrors: Signal<SessionServiceError, NoError> = self.initializeLoginErrorsSignal()
    public private(set) lazy var logInExecuting: Signal<Bool, NoError> = self.initializeLoginExecutingSignal()
    public private(set) lazy var logInSuccessful: Signal<(), NoError> = self.initializeLogInSuccesfulSignal()
    
    public var togglePasswordVisibility: CocoaAction<UIButton> { return CocoaAction(_togglePasswordVisibility) }
    
    fileprivate lazy var _logIn: Action<(), User, SessionServiceError> = self.initializeLogInAction()
    fileprivate let _logInProvidersUserSignal: Signal<LoginProviderUserType, NoError>
    fileprivate let _logInProvidersErrorSignal: Signal<LoginProviderErrorType, NoError>
    fileprivate lazy var _logInProvidersFinalUserSignal: Signal<Result<User, SessionServiceError>, NoError> = self.initializeLogInUserSignal()
    
    // The providers executing signal can only track the login to the session service,
    //  after the login with the login provider was successful.
    // This wouldn't affect the UX since the providers are supposed to present a view
    //  for logging in and close it after it succeeded or failed.
    fileprivate let _loginProvidersExecutingSignal: Signal<Bool, NoError>
    fileprivate let _loginProvidersExecutingObserver: Observer<Bool, NoError>
    
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
                  providerSignals: [(Signal<LoginProviderUserType, NoError>, Signal<LoginProviderErrorType, NoError>)] = []) { //swiftlint:disable:this large_tuple
        _sessionService = sessionService
        
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        
        let credentialsValidationResults = Signal.combineLatest(emailValidationResult.map { $0.isValid },
                                                                passwordValidationResult.map { $0.isValid })
        _credentialsAreValid = Property(initial: false, then: credentialsValidationResults.map { $0 && $1 })
        
        emailValidationErrors = Property(initial: [], then: emailValidationResult.map { $0.errors })
        passwordValidationErrors = Property(initial: [], then: passwordValidationResult.map { $0.errors })
        
        _logInProvidersUserSignal = Signal.merge(providerSignals.map { $0.0 })
        _logInProvidersErrorSignal = Signal.merge(providerSignals.map { $0.1 })
        
        (_loginProvidersExecutingSignal, _loginProvidersExecutingObserver) = Signal.pipe()
    }
    
}

//---------------------------------------
//TODO: Extract to WolmoCore

extension SignalProducer {
    
    func toResultSignalProducer() -> SignalProducer<Result<Value, Error>, NoError> {
        return map { Result<Value, Error>.success($0) }
            .flatMapError { error -> SignalProducer<Result<Value, Error>, NoError> in
                let errorValue = Result<Value, Error>.failure(error)
                return SignalProducer<Result<Value, Error>, NoError>(value: errorValue)
        }
    }
    
}

extension SignalProducer where Value: ResultProtocol {
    
    func filterValues() -> SignalProducer<Value.Value, Error> {
        return filter {
            if let _ = $0.value {
                return true
            }
            return false
        }.map { $0.value! }
    }
    
    func filterErrors() -> SignalProducer<Value.Error, Error> {
        return filter {
            if let _ = $0.error {
                return true
            }
            return false
        }.map { $0.error! }
    }
    
}

extension Signal where Value: ResultProtocol {
    
    func filterValues() -> Signal<Value.Value, Error> {
        return filter {
            if let _ = $0.value {
                return true
            }
            return false
        }.map { $0.value! }
    }
    
    func filterErrors() -> Signal<Value.Error, Error> {
        return filter {
            if let _ = $0.error {
                return true
            }
            return false
        }.map { $0.error! }
    }
    
}

extension Signal {
    
    func toResultSignal() -> Signal<Result<Value, Error>, NoError> {
        return map { Result<Value, Error>.success($0) }
            .flatMapError { error -> SignalProducer<Result<Value, Error>, NoError> in
                let errorValue = Result<Value, Error>.failure(error)
                return SignalProducer<Result<Value, Error>, NoError>(value: errorValue)
        }
    }
    
}

//-------------------

fileprivate extension LoginViewModel {
    
    fileprivate func initializeLogInUserSignal() -> Signal<Result<User, SessionServiceError>, NoError> {
        let usersSignal = _logInProvidersUserSignal.flatMap(.latest) {
            [unowned self] loginProviderUserType -> SignalProducer<Result<User, SessionServiceError>, NoError> in
                return self._sessionService.logIn(withUser: loginProviderUserType)
                                .on(started: { [unowned self] in
                                    self._loginProvidersExecutingObserver.send(value: true)
                                }, failed: { [unowned self] _ in
                                    self._loginProvidersExecutingObserver.send(value: false)
                                }, completed: {
                                    self._loginProvidersExecutingObserver.send(value: false)
                                }, interrupted: {
                                    self._loginProvidersExecutingObserver.send(value: false)
                                }, terminated: {
                                    self._loginProvidersExecutingObserver.send(value: false)
                                }).toResultSignalProducer()
        }
        let errorsSignal = _logInProvidersErrorSignal.map { Result<User, SessionServiceError>.failure($0.sessionServiceError) }
        return Signal.merge([usersSignal, errorsSignal])
    }
    
    fileprivate func initializeLogInSuccesfulSignal() -> Signal<Void, NoError> {
        let successfullyLoggedInWithProvidersSignal = _logInProvidersFinalUserSignal.filterValues().map { _ in () }
        let successfullyLoggedInWithMailSignal = _logIn.values.map { _ in () }
        return Signal.merge([successfullyLoggedInWithProvidersSignal, successfullyLoggedInWithMailSignal])
    }
    
    fileprivate func initializeLoginErrorsSignal() -> Signal<SessionServiceError, NoError> {
        let loginWithMailErrors = _logIn.errors
        let loginWithProvidersErrors = _logInProvidersFinalUserSignal.filterErrors()
        return Signal.merge([loginWithMailErrors, loginWithProvidersErrors])
    }
    
    fileprivate func initializeLoginExecutingSignal() -> Signal<Bool, NoError> {
        return Signal.merge([_logIn.isExecuting.signal, _loginProvidersExecutingSignal])
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

fileprivate extension LoginProviderErrorType {
    
    var sessionServiceError: SessionServiceError {
        switch self {
        case let .facebook(error: error): return .loginProviderError(name: FacebookLoginProvider.name, error: error)
        case let .custom(name: name, error: error): return .loginProviderError(name: name, error: error)
        }
    }
    
}
