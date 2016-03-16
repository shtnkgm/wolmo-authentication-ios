//
//  EmailValidatorTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

class EmailValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("EmailValidator") {
            
            beforeEach() {
                validator = EmailValidator()
            }
            
            it("does not accept an email not conforming to the pattern") {
                expect(validator.validate("email").isValid).to(beFalse())
            }
            
            it("accepts any email conforming to the pattern") {
                expect(validator.validate("user@email.com").isValid).to(beTrue())
            }
            
        }
        
    }
    
}
