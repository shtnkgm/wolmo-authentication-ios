//
//  CompositeValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct CompositeTextInputValidator: TextInputValidatorType {
    
    private let _validators: [TextInputValidatorType]
    
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
    
    public func addValidator(newValidator: TextInputValidatorType) -> CompositeTextInputValidator {
        var validators = _validators
        validators.append(newValidator)
        return CompositeTextInputValidator(validators: validators)
    }
    
}
