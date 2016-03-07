//
//  LogInViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa


public class LogInViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User> {
    
    public let email = MutableProperty(" ")
    public let emailValidationErrors: AnyProperty<[String]>
    
    public let password = MutableProperty(" ")
    public let passwordValidationErrors: AnyProperty<[String]>
    public let showPassword = MutableProperty(false)
    
    public var login: Action<AnyObject, User, NSError>!

    
    public init(sessionService: SessionService, credentialsValidator: LogInCredentialsValidator = LogInCredentialsValidator()) {
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        
        let credentialsAreValid = AnyProperty(
            initialValue: false,
            signal: combineLatest(emailValidationResult.map{ $0.isValid }, passwordValidationResult.map{ $0.isValid }).map { $0 && $1 }
        )
        
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
        
        login = .None
        login = Action(enabledIf: credentialsAreValid) { [unowned self] _ in
            let email = Email(raw: self.email.value)!
            let password = self.password.value
            return sessionService.login(email, password).observeOn(UIScheduler())
        }
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
        return "password-visibility.title".localized(!showPassword.value)
    }
    
    
}