//
//  LogInViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError


public protocol LogInViewModelType {
    
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    var showPassword: MutableProperty<Bool> { get }
    
    var togglePasswordVisibility: Action<AnyObject?, Bool, NoError> { get }
    var logInCocoaAction: CocoaAction { get }
    var logInErrors: Signal<NSError, NoError> { get }
    var logInExecuting: Signal<Bool, NoError> { get }
    
    var emailText: String { get }
    var passwordText: String { get }
    var emailPlaceholderText: String { get }
    var passwordPlaceholderText: String { get }
    var loginButtonTitle: String { get }
    var registerButtonTitle: String { get }
    var termsAndServicesButtonTitle: String { get }
    var passwordVisibilityButtonTitle : String { get }
    
}

public final class LogInViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User> : LogInViewModelType {
    
    private let _credentialsAreValid: AnyProperty<Bool>
    private let _sessionService: SessionService
    
    public let email = MutableProperty("")
    public let emailValidationErrors: AnyProperty<[String]>
    
    public let password = MutableProperty("")
    public let passwordValidationErrors: AnyProperty<[String]>
    public let showPassword = MutableProperty(false)
    
    private lazy var _logIn: Action<AnyObject?, User, NSError> = {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            let email = Email(raw: self.email.value)!
            let password = self.password.value
            return self._sessionService.login(email, password).observeOn(UIScheduler())
        }
    }()
    public var logInCocoaAction: CocoaAction { return _logIn.unsafeCocoaAction }
    public var logInErrors: Signal<NSError, NoError> { return _logIn.errors }
    public var logInExecuting: Signal<Bool, NoError> { return _logIn.executing.signal }
    
    
    public private(set) lazy var togglePasswordVisibility: Action<AnyObject?, Bool, NoError> = {
        return Action { [unowned self] _ in
            self.showPassword.value = !self.showPassword.value
            return SignalProducer(value: self.showPassword.value)
        }
    }()
    
    public init(sessionService: SessionService, credentialsValidator: LogInCredentialsValidator = LogInCredentialsValidator()) {
        _sessionService = sessionService
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        
        let credentialsValidationResults = combineLatest(
            emailValidationResult.map{ $0.isValid },
            passwordValidationResult.map{ $0.isValid }
        )
        _credentialsAreValid = AnyProperty(
            initialValue: false,
            signal: credentialsValidationResults.map { $0 && $1 }
        )
        
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
    }
    
}

public extension LogInViewModel {
    
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
        return "login-view-model.email-placeholder".localized
    }
    
    var loginButtonTitle: String {
        return "login-view-model.login-button-title".localized
    }
    
    var registerButtonTitle: String {
        return "login-view-model.register-button-title".localized
    }
    
    var termsAndServicesButtonTitle: String {
        return "login-view-model.terms-and-services-button-title".localized
    }
    
    var passwordVisibilityButtonTitle : String {
        return ("password-visibility.button-title." + (showPassword.value ? "false" : "true")).localized
    }
    
    
}