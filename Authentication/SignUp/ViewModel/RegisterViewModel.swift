//
//  RegisterViewModel.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError


protocol RegisterViewModelType {
    
    var name: MutableProperty<String> { get }
    var nameValidationErrors: AnyProperty<[String]> { get }
    
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    
    var passwordConfirmation: MutableProperty<String> { get }
    var passwordConfirmationValidationErrors: AnyProperty<[String]> { get }
    
    var nameText: String { get }
    var emailText: String { get }
    var passwordText: String { get }
    var confirmPasswordText: String { get }
    var namePlaceholderText: String { get }
    var emailPlaceholderText: String { get }
    var passwordPlaceholderText: String { get }
    var confirmPasswordPlaceholderText: String { get }
    var signupButtonTitle: String { get }
    
}

public final class RegisterViewModel: RegisterViewModelType {
    
    public let name = MutableProperty("")
    public let email = MutableProperty("")
    public let password = MutableProperty("")
    public let passwordConfirmation = MutableProperty("")
    
    public let nameValidationErrors: AnyProperty<[String]>
    public let emailValidationErrors: AnyProperty<[String]>
    public let passwordValidationErrors: AnyProperty<[String]>
    public let passwordConfirmationValidationErrors: AnyProperty<[String]>
    
    init(credentialsValidator: SignupCredentialsValidator = SignupCredentialsValidator()) {
        let nameValidationResult = name.signal.map(credentialsValidator.nameValidator.validate)
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        let passwordConfirmValidationResult = combineLatest(password.signal, passwordConfirmation.signal)
            .map { $0 == $1 }.map { equals -> ValidationResult in
                if equals {
                    return .Valid
                } else {
                    return .invalid("signup.password-confirmation.invalid".localized)
                }
        }
        
        nameValidationErrors = AnyProperty(initialValue: [], signal: nameValidationResult.map { $0.errors })
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
        passwordConfirmationValidationErrors = AnyProperty(initialValue: [], signal: passwordConfirmValidationResult.map { $0.errors })
    }
    
}

public extension RegisterViewModel {
    
    public var nameText: String {
        return "signup-view-model.name".localized
    }
    
    public var emailText: String {
        return "signup-view-model.email".localized
    }
    
    public var passwordText: String {
        return "signup-view-model.password".localized
    }
    
    public var confirmPasswordText: String {
        return "signup-view-model.confirm-password".localized
    }
    
    public var namePlaceholderText: String {
        return "signup-view-model.name-placeholder".localized
    }
    
    public var emailPlaceholderText: String {
        return "signup-view-model.email-placeholder".localized
    }
    
    public var passwordPlaceholderText: String {
        return "signup-view-model.password-placeholder".localized
    }
    
    public var confirmPasswordPlaceholderText: String {
        return "signup-view-model.confirm-password-placeholder".localized
    }
    
    public var signupButtonTitle: String {
        return "signup-view-model.signup-button-title".localized
    }
    
}
