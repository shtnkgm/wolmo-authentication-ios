//
//  Validator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


public enum ValidationResult {
    
    public static func invalid(errorMessage: String) -> ValidationResult {
        return .Invalid(errors: [errorMessage])
    }
    
    case Valid
    case Invalid(errors: [String])
    
    var isValid: Bool {
        switch self {
        case .Valid: return true
        case .Invalid(_): return false
        }
    }
    
    var errors: [String] {
        switch self {
        case .Valid: return []
        case .Invalid(let _errors): return _errors
        }
    }
    
}

public protocol TextInputValidatorType {
    
    func validate(text: String) -> ValidationResult
    
}

public struct CompositeTextInputValidator: TextInputValidatorType {
    
    private var _validators: [TextInputValidatorType]
    
    init(validators: [TextInputValidatorType]) {
        _validators = validators
    }
    
    public func validate(text: String) -> ValidationResult {
        return _validators.reduce(.Valid) { result, validator in
            switch (result, validator.validate(text)) {
            case (.Invalid(let left), .Invalid(let right)): return .Invalid(errors: left + right)
            case (let invalid, .Valid): return invalid
            case (.Valid, let invalid): return invalid
            default: return .Valid
            }
        }
    }
    
}

public struct AnyTextInputValidator: TextInputValidatorType {
    
    private let _validate: String -> ValidationResult
    
    init(validate: String -> ValidationResult) {
        _validate = validate
    }
    
    public func validate(text: String) -> ValidationResult {
        return _validate(text)
    }
    
}



public struct NonEmptyValidator : TextInputValidatorType {
    
    public func validate(text: String) -> ValidationResult {
        if text.isEmpty {
            return .Invalid(errors: ["text-input-validator.empty".localized])
        } else {
            return .Valid
        }
    }
    
}

public struct EmailValidator : TextInputValidatorType {
    
    public func validate(text: String) -> ValidationResult {
        if Email.isValidEmail(text) {
            return .Valid
        } else {
            return .Invalid(errors: ["text-input-validator.invalid-email".localized(text)])
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
            return .Invalid(errors: ["text-input-validator.max-length".localized(_maxLength)])
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
        if text.characters.count > _minLength {
            return .Invalid(errors: ["text-input-validator.min-length".localized(_minLength)])
        } else {
            return .Valid
        }
    }
    
}


