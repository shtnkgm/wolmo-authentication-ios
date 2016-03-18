//
//  InlineValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


public struct AnyTextInputValidator: TextInputValidatorType {
    
    private let _validate: String -> ValidationResult
    
    init(validate: String -> ValidationResult) {
        _validate = validate
    }
    
    public func validate(text: String) -> ValidationResult {
        return _validate(text)
    }
    
}
