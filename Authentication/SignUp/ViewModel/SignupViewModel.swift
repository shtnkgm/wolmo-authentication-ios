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


public protocol SignupViewModelType {
    
    var name: MutableProperty<String> { get }
    var nameValidationErrors: AnyProperty<[String]> { get }
    
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    var showPassword: MutableProperty<Bool> { get }
    var togglePasswordVisibilityCocoaAction: CocoaAction { get }
    
    var passwordConfirmationValidationEnabled: Bool { get set }
    var passwordConfirmation: MutableProperty<String> { get }
    var passwordConfirmationValidationErrors: AnyProperty<[String]> { get }
    var showConfirmationPassword: MutableProperty<Bool> { get }
    var toggleConfirmPswdVisibilityCocoaAction: CocoaAction { get }
    
    var signUpCocoaAction: CocoaAction { get }
    var signUpErrors: Signal<SessionServiceError, NoError> { get }
    var signUpExecuting: Signal<Bool, NoError> { get }
    
}

public final class SignupViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User>: SignupViewModelType {
    
    private let _sessionService: SessionService
    
    private let _nameValidationResult: Signal<ValidationResult, NoError>
    private let _emailValidationResult: Signal<ValidationResult, NoError>
    private let _passwordValidationResult: Signal<ValidationResult, NoError>
    private let _passwordConfirmValidationResult: Signal<ValidationResult, NoError>
    
    private lazy var _credentialsAreValid: AndProperty = self.initializeCredentialsValidationBoolProperty()
    
    public let name = MutableProperty("")
    public let email = MutableProperty("")
    public let password = MutableProperty("")
    public let passwordConfirmation = MutableProperty("")
    
    public var passwordConfirmationValidationEnabled: Bool = true
    
    public let nameValidationErrors: AnyProperty<[String]>
    public let emailValidationErrors: AnyProperty<[String]>
    public let passwordValidationErrors: AnyProperty<[String]>
    public let passwordConfirmationValidationErrors: AnyProperty<[String]>
    
    public let showPassword = MutableProperty(false)
    public let showConfirmationPassword = MutableProperty(false)
    
    public var signUpCocoaAction: CocoaAction { return _signUp.unsafeCocoaAction }
    public var signUpErrors: Signal<SessionServiceError, NoError> { return _signUp.errors }
    public var signUpExecuting: Signal<Bool, NoError> { return _signUp.executing.signal }
    
    public var togglePasswordVisibilityCocoaAction: CocoaAction { return _togglePasswordVisibility.unsafeCocoaAction }
    public var toggleConfirmPswdVisibilityCocoaAction: CocoaAction { return _toggleConfirmationPasswordVisibility.unsafeCocoaAction }
    
    private lazy var _signUp: Action<AnyObject, User, SessionServiceError> = {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                return self._sessionService.signUp(self.name.value, email: email, password: self.password.value)
            } else {
                return SignalProducer(error: .InvalidSignUpCredentials(.None)).observeOn(UIScheduler())
            }
        }
    }()
    
    private lazy var _togglePasswordVisibility: Action<AnyObject, Bool, NoError> = self.initializeTogglePasswordVisibilityAction()
    private lazy var _toggleConfirmationPasswordVisibility: Action<AnyObject, Bool, NoError> = self.initializeToggleConfirmationPasswordVisibilityAction()
    
    // If there is no username in the view, the credentials validator's nameValidator.validate should always return true.
    internal init(sessionService: SessionService, credentialsValidator: SignupCredentialsValidator = SignupCredentialsValidator()) {
        _sessionService = sessionService
        
        _nameValidationResult = name.signal.map(credentialsValidator.nameValidator.validate)
        _emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        _passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        _passwordConfirmValidationResult = combineLatest(password.signal, passwordConfirmation.signal)
            .map { $0 == $1 }.map(getPasswordConfirmValidationResultFromEquality)
        
        nameValidationErrors = AnyProperty(initialValue: [], signal: _nameValidationResult.map { $0.errors })
        emailValidationErrors = AnyProperty(initialValue: [], signal: _emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: _passwordValidationResult.map { $0.errors })
        passwordConfirmationValidationErrors = AnyProperty(initialValue: [], signal: _passwordConfirmValidationResult.map { $0.errors })
        
        // Can't initialize `_credentialsAreValid` here, because the controller will change
        // the `passwordConfirmationValidationEnabled` property afterwards, in the `viewDidLoad` method.
    }
    
}

private extension SignupViewModel {
    
    private func initializeCredentialsValidationBoolProperty() -> AndProperty {
        return AnyProperty<Bool>(initialValue: false, signal: self._nameValidationResult.map { $0.isValid })
            .and(AnyProperty<Bool>(initialValue: false, signal: self._emailValidationResult.map { $0.isValid }))
            .and(AnyProperty<Bool>(initialValue: false, signal: self._passwordValidationResult.map { $0.isValid }))
            .and(AnyProperty<Bool>(initialValue: false, signal: self._passwordConfirmValidationResult.map { [unowned self] in
                if self.passwordConfirmationValidationEnabled { return $0.isValid } else { return true }
        }))
    }
    
    private func initializeTogglePasswordVisibilityAction() -> Action<AnyObject, Bool, NoError> {
        return Action { [unowned self] _ in
            self.showPassword.value = !self.showPassword.value
            return SignalProducer(value: self.showPassword.value).observeOn(UIScheduler())
        }
    }
    
    private func initializeToggleConfirmationPasswordVisibilityAction() -> Action<AnyObject, Bool, NoError> {
        return Action { [unowned self] _ in
            self.showConfirmationPassword.value = !self.showConfirmationPassword.value
            return SignalProducer(value: self.showConfirmationPassword.value).observeOn(UIScheduler())
        }
    }
    
}

private func getPasswordConfirmValidationResultFromEquality(equals: Bool) -> ValidationResult {
    if equals {
        return .Valid
    } else {
        return .invalid("signup-error.password-confirmation.invalid".localized)
    }
}
