//
//  ConstantValidators.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Core

public struct AlwaysValidValidator: TextInputValidatorType {
    
    public func validate(text: String) -> ValidationResult {
        return .Valid
    }
    
}

public struct AlwaysInvalidValidator: TextInputValidatorType {
    
    public var errorTextToLocalize: String = ""
    
    public func validate(text: String) -> ValidationResult {
        return .Invalid(errors: [errorTextToLocalize.frameworkLocalized(text)])
    }
    
}
