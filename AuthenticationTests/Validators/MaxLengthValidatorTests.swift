//
//  MaxLengthValidatorTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

class MaxLengthValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("MaxLengthValidator") {
            
            beforeEach() {
                validator = MaxLengthValidator(maxLength: 6)
            }
            
            it("does not accept a text longer than 6") {
                expect(validator.validate("this is a long text").isValid).to(beFalse())
            }
            
            it("accepts any text shorter than 6") {
                expect(validator.validate("").isValid).to(beTrue())
            }
            
            it("accepts any text of length 6") {
                expect(validator.validate("123456").isValid).to(beTrue())
            }
            
        }
        
    }
    
}

