//
//  CompositeValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents a composite validator which
     will validate according to all criteria
     embedded in all the TextInputValidator s
     associated.
     A text is valid only when it is valid for
     all and each of the validators associated.
     An invalid text will be accompanied by all
     the invalid errors provided by the validators
     associated.
 */
public struct CompositeTextInputValidator: TextInputValidatorType {
    
    private let _validators: [TextInputValidatorType]
    
    init(validators: [TextInputValidatorType]) {
        _validators = validators
    }
    
    public func validate(_ text: String) -> ValidationResult {
        return _validators.reduce(.valid) { result, validator in
            switch (result, validator.validate(text)) {
            case (.invalid(let left), .invalid(let right)): return .invalid(errors: left + right)
            case (let invalid, .valid): return invalid
            case (.valid, let invalid): return invalid
            default: return .valid
            }
        }
    }
    
    public func addValidator(_ newValidator: TextInputValidatorType) -> CompositeTextInputValidator {
        var validators = _validators
        validators.append(newValidator)
        return CompositeTextInputValidator(validators: validators)
    }
    
}
