//
//  MinLengthValidatorTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

class MinLengthValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("MinLengthValidator") {
            
            beforeEach() {
                validator = MinLengthValidator(minLength: 3)
            }
            
            it("does not accept a text shorter than 3") {
                expect(validator.validate("ab").isValid).to(beFalse())
            }
            
            it("accepts any text longer than 3") {
                expect(validator.validate("text").isValid).to(beTrue())
            }
            
            it("accepts any text of length 3") {
                expect(validator.validate("123").isValid).to(beTrue())
            }
            
        }
        
    }
    
}
