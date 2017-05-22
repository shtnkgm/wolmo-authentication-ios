//
//  LoginCredentialsValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents a validator for all login fields:
     email and password.
     It provides default validators for each of them.
 */
public struct LoginCredentialsValidator {
    
    public static func defaultEmailValidator() -> TextInputValidatorType {
        return  CompositeTextInputValidator(validators: [
                NonEmptyValidator(),
                EmailValidator()
                ])
    }
    
    public static func defaultPasswordValidator(withMinLength minLength: Int = 4, maxLength: Int? = 30) -> TextInputValidatorType {
        var validators: [TextInputValidatorType] = [
                NonEmptyValidator(),
                MinLengthValidator(minLength: minLength)
            ]
        if let max = maxLength {
            validators.append(MaxLengthValidator(maxLength: max))
        }
        return CompositeTextInputValidator(validators: validators)
    }
    
    public let emailValidator: TextInputValidatorType
    public let passwordValidator: TextInputValidatorType
    
    public init(emailValidator: TextInputValidatorType = LoginCredentialsValidator.defaultEmailValidator(),
         passwordValidator: TextInputValidatorType = LoginCredentialsValidator.defaultPasswordValidator()) {
            self.emailValidator = emailValidator
            self.passwordValidator = passwordValidator
    }
    
}
