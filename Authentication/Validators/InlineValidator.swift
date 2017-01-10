//
//  InlineValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents a validator which will validate
     according to the validating function associated.
 */
public struct AnyTextInputValidator: TextInputValidatorType {
    
    private let _validate: (String) -> ValidationResult
    
    init(validate: @escaping (String) -> ValidationResult) {
        _validate = validate
    }
    
    public func validate(_ text: String) -> ValidationResult {
        return _validate(text)
    }
    
}
