//
//  LengthValidators.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct NonEmptyValidator: TextInputValidatorType {
    
    public func validate(text: String) -> ValidationResult {
        if text.isEmpty {
            return .Invalid(errors: ["text-input-validator.empty".frameworkLocalized])
        } else {
            return .Valid
        }
    }
    
}

public struct MaxLengthValidator: TextInputValidatorType {
    
    private let _maxLength: Int
    
    public init(maxLength: Int) {
        _maxLength = maxLength
    }
    
    public func validate(text: String) -> ValidationResult {
        if text.characters.count > _maxLength {
            return .Invalid(errors: ["text-input-validator.max-length".frameworkLocalized(_maxLength)])
        } else {
            return .Valid
        }
    }
    
}

public struct MinLengthValidator: TextInputValidatorType {
    
    private let _minLength: Int
    
    public init(minLength: Int) {
        _minLength = minLength
    }
    
    public func validate(text: String) -> ValidationResult {
        if text.characters.count < _minLength {
            return .Invalid(errors: ["text-input-validator.min-length".frameworkLocalized(_minLength)])
        } else {
            return .Valid
        }
    }
    
}
