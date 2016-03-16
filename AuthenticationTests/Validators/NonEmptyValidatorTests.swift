//
//  NonEmptyValidatorTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

class NonEmptyValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("NonEmptyValidator") {
            
            beforeEach() {
                validator = NonEmptyValidator()
            }
            
            it("should not accept an empty text") {
                expect(validator.validate("").isValid).to(beFalse())
            }
            
            it("should accept any string which is not empty") {
                expect(validator.validate("text").isValid).to(beTrue())
            }
            
        }
        
    }
    
}
