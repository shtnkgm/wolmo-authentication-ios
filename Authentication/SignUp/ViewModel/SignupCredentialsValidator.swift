//
//  SignupCredentialsValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/23/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
    Represents a validator for all signup fields:
    username, email and password.
    It provides default validators for each of them.
*/
public struct SignupCredentialsValidator {
    
    public static func defaultUsernameValidator() -> TextInputValidatorType {
        return NonEmptyValidator()
    }
    
    public static func defaultEmailValidator() -> TextInputValidatorType {
        return  CompositeTextInputValidator(validators: [
            NonEmptyValidator(),
            EmailValidator()
        ])
    }
    
    public static func defaultPasswordValidator(minLength: Int = 4, maxLength: Int? = 30) -> TextInputValidatorType {
        var validators: [TextInputValidatorType] = [
            NonEmptyValidator(),
            MinLengthValidator(minLength: minLength)
        ]
        if let max = maxLength {
            validators.append(MaxLengthValidator(maxLength: max))
        }
        return CompositeTextInputValidator(validators: validators)
    }
    
    public let usernameValidator: TextInputValidatorType
    public let emailValidator: TextInputValidatorType
    public let passwordValidator: TextInputValidatorType
    
    init(usernameValidator: TextInputValidatorType = SignupCredentialsValidator.defaultUsernameValidator(),
        emailValidator: TextInputValidatorType = SignupCredentialsValidator.defaultEmailValidator(),
        passwordValidator: TextInputValidatorType = SignupCredentialsValidator.defaultPasswordValidator()) {
            self.usernameValidator = usernameValidator
            self.emailValidator = emailValidator
            self.passwordValidator = passwordValidator
    }
    
}
