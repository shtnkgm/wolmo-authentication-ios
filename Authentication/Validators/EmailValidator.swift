//
//  EmailValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/*
     Represents an email validator,
     according to the Email's valid criteria.
 */
public struct EmailValidator: TextInputValidatorType {
    
    public func validate(text: String) -> ValidationResult {
        if Email.isValidEmail(text) {
            return .Valid
        } else {
            return .Invalid(errors: ["text-input-validator.invalid-email".frameworkLocalized(text)])
        }
    }
    
}
