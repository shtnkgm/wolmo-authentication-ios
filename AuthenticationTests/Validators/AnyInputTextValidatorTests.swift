//
//  AnyInputTextValidatorTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/14/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication


class AnyInputTextValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("AnyTextInputValidator") {
            
            beforeEach() {
                validator = AnyTextInputValidator { text in
                    if text == "myText" {
                        return .Valid
                    } else {
                        return .Invalid(errors: ["Not expected text"])
                    }
                }
            }
            
            it("does not accept a text which isn't what expected") {
                expect(validator.validate("email").isValid).to(beFalse())
            }
            
            it("accepts a text which is what expected") {
                expect(validator.validate("myText").isValid).to(beTrue())
            }
            
        }
        
    }
    
}