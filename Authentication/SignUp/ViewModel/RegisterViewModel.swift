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
import Rex


public protocol RegisterViewModelType {
    
    var name: MutableProperty<String> { get }
    var nameValidationErrors: AnyProperty<[String]> { get }
    
    var email: MutableProperty<String> { get }
    var emailValidationErrors: AnyProperty<[String]> { get }
    
    var password: MutableProperty<String> { get }
    var passwordValidationErrors: AnyProperty<[String]> { get }
    
    var passwordConfirmation: MutableProperty<String> { get }
    var passwordConfirmationValidationErrors: AnyProperty<[String]> { get }
    
    var termsAndServicesAccepted: MutableProperty<Bool> { get }
    
    var toggleTermsAndServicesCocoaAction: CocoaAction { get }
    var signUpCocoaAction: CocoaAction { get }
    var signUpErrors: Signal<SessionServiceError, NoError> { get }
    var signUpExecuting: Signal<Bool, NoError> { get }
    
    var nameText: String { get }
    var emailText: String { get }
    var passwordText: String { get }
    var confirmPasswordText: String { get }
    var namePlaceholderText: String { get }
    var emailPlaceholderText: String { get }
    var passwordPlaceholderText: String { get }
    var confirmPasswordPlaceholderText: String { get }
    var termsAndServicesLabelText: String { get }
    var termsAndServicesButtonTitle: String { get }
    var signupButtonTitle: String { get }
    
}

public final class RegisterViewModel<User: UserType, SessionService: SessionServiceType where SessionService.User == User>: RegisterViewModelType {
    
    private let _sessionService: SessionService
    private let _credentialsAreValid: AndProperty
    
    public let name = MutableProperty("")
    public let email = MutableProperty("")
    public let password = MutableProperty("")
    public let passwordConfirmation = MutableProperty("")
    public let termsAndServicesAccepted = MutableProperty(false)
    
    public let nameValidationErrors: AnyProperty<[String]>
    public let emailValidationErrors: AnyProperty<[String]>
    public let passwordValidationErrors: AnyProperty<[String]>
    public let passwordConfirmationValidationErrors: AnyProperty<[String]>
    public let termsAndServicesValidationErrors: AnyProperty<[String]>
    
    private lazy var _signUp: Action<AnyObject, User, SessionServiceError> = {
        return Action(enabledIf: self._credentialsAreValid) { [unowned self] _ in
            if let email = Email(raw: self.email.value) {
                return self._sessionService.signUp(self.name.value, email, self.password.value)
            } else {
                return SignalProducer(error: .InvalidSignUpCredentials(.None)).observeOn(UIScheduler())
            }
        }
    }()
    
    public var signUpCocoaAction: CocoaAction { return _signUp.unsafeCocoaAction }
    public var signUpErrors: Signal<SessionServiceError, NoError> { return _signUp.errors }
    public var signUpExecuting: Signal<Bool, NoError> { return _signUp.executing.signal }
    
    private lazy var _toggleTermsAndServicesAcceptance: Action<AnyObject, Bool, NoError> = {
        return Action { [unowned self] _ in
            self.termsAndServicesAccepted.value = !self.termsAndServicesAccepted.value
            return SignalProducer(value: self.termsAndServicesAccepted.value).observeOn(UIScheduler())
        }
    }()
    
    public var toggleTermsAndServicesCocoaAction: CocoaAction { return _toggleTermsAndServicesAcceptance.unsafeCocoaAction }
    
    init(sessionService: SessionService, credentialsValidator: SignupCredentialsValidator = SignupCredentialsValidator()) {
        _sessionService = sessionService
        
        let nameValidationResult = name.signal.map(credentialsValidator.nameValidator.validate)
        let emailValidationResult = email.signal.map(credentialsValidator.emailValidator.validate)
        let passwordValidationResult = password.signal.map(credentialsValidator.passwordValidator.validate)
        let passwordConfirmValidationResult = combineLatest(password.signal, passwordConfirmation.signal)
            .map { $0 == $1 }.map(getPasswordConfirmValidationResultFromEquality)
        let termsAndServicesValidationResult = termsAndServicesAccepted.signal.map(getTermsAndServicesValidationResultFromAcceptance)

        nameValidationErrors = AnyProperty(initialValue: [], signal: nameValidationResult.map { $0.errors })
        emailValidationErrors = AnyProperty(initialValue: [], signal: emailValidationResult.map { $0.errors })
        passwordValidationErrors = AnyProperty(initialValue: [], signal: passwordValidationResult.map { $0.errors })
        passwordConfirmationValidationErrors = AnyProperty(initialValue: [], signal: passwordConfirmValidationResult.map { $0.errors })
        termsAndServicesValidationErrors = AnyProperty(initialValue: [], signal: termsAndServicesValidationResult.map { $0.errors })
        
        _credentialsAreValid = AnyProperty<Bool>(initialValue: false, signal: nameValidationResult.map { $0.isValid })
                            .and(AnyProperty<Bool>(initialValue: false, signal: emailValidationResult.map { $0.isValid }))
                            .and(AnyProperty<Bool>(initialValue: false, signal: passwordValidationResult.map { $0.isValid }))
                            .and(AnyProperty<Bool>(initialValue: false, signal:passwordConfirmValidationResult.map { $0.isValid }))
                            .and(termsAndServicesAccepted)
    }
    
}

private func getPasswordConfirmValidationResultFromEquality(equals: Bool) -> ValidationResult {
    if equals {
        return .Valid
    } else {
        return .invalid("signup.password-confirmation.invalid".localized)
    }
}

private func getTermsAndServicesValidationResultFromAcceptance(accepted: Bool) -> ValidationResult {
    if accepted {
        return .Valid
    } else {
        return .invalid("signup.terms-and-services.not-accepted".localized)
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
    
    public var termsAndServicesLabelText: String {
        return "signup-view-model.terms-and-services.label-text".localized
    }
    
    public var termsAndServicesButtonTitle: String {
        return "signup-view-model.terms-and-services.button-title".localized
    }
    public var signupButtonTitle: String {
        return "signup-view-model.signup-button-title".localized
    }
    
}
