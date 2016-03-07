//
//  LogInCredentialsValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


public struct LogInCredentialsValidator {
    
    public static func defaultEmailValidator() -> TextInputValidatorType {
        return  CompositeTextInputValidator(validators: [
                NonEmptyValidator(),
                EmailValidator()
                ])
    }
    
    public static func defaultPasswordValidator(minLength: Int = 4, maxLength: Int = 30) -> TextInputValidatorType {
        return CompositeTextInputValidator(validators: [
            NonEmptyValidator(),
            MinLengthValidator(minLength: minLength),
            MaxLengthValidator(maxLength: maxLength)
            ])
    }
    
    public let emailValidator: TextInputValidatorType
    public let passwordValidator: TextInputValidatorType
    
    init(emailValidator: TextInputValidatorType = LogInCredentialsValidator.defaultEmailValidator(),
        passwordValidator : TextInputValidatorType = LogInCredentialsValidator.defaultPasswordValidator()) {
            self.emailValidator = emailValidator
            self.passwordValidator = passwordValidator
    }
    
}