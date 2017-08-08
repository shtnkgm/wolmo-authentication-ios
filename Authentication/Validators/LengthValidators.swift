//
//  LengthValidators.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
     Represents a validator which will validate
     the text is not empty.
 */
public struct NonEmptyValidator: TextInputValidatorType {
    
    public init() { }
    
    public func validate(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .invalid(errors: ["text-input-validator.empty".frameworkLocalized])
        } else {
            return .valid
        }
    }
    
}

/**
     Represents a validator which will validate
     the text is no longer than the quantity of
     characters associated.
     (That is to say, any text with that exact 
     quantity or less is valid)
 */
public struct MaxLengthValidator: TextInputValidatorType {
    
    private let _maxLength: Int
    
    public init(maxLength: Int) {
        _maxLength = maxLength
    }
    
    public func validate(_ text: String) -> ValidationResult {
        if text.characters.count > _maxLength {
            return .invalid(errors: ["text-input-validator.max-length".frameworkLocalized(withArguments: _maxLength)])
        } else {
            return .valid
        }
    }
    
}

/**
     Represents a validator which will validate
     the text is no shorter than the quantity of
     characters associated.
     (That is to say, any text with that exact
     quantity or more is valid)
 */
public struct MinLengthValidator: TextInputValidatorType {
    
    private let _minLength: Int
    
    public init(minLength: Int) {
        _minLength = minLength
    }
    
    public func validate(_ text: String) -> ValidationResult {
        if text.characters.count < _minLength {
            return .invalid(errors: ["text-input-validator.min-length".frameworkLocalized(withArguments: _minLength)])
        } else {
            return .valid
        }
    }
    
}
