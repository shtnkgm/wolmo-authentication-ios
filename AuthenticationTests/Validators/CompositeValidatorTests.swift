//
//  CompositeValidator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

class CompositeValidatorSpec: QuickSpec {
    
    override func spec() {
        
        var validator: CompositeTextInputValidator!
        
        describe("CompositeTextInputValidator") {
            
            beforeEach() {
                validator = CompositeTextInputValidator(validators:
                    [NonEmptyValidator(),
                        AnyTextInputValidator { text in
                            if text.contains("substring") {
                                return .invalid(errors: ["The string contains invalid word 'substring'"])
                            } else {
                                return .valid
                            }
                        },
                        MaxLengthValidator(maxLength: 10)]
                )
            }
            
            it("returns one error if only one validator doesn't pass") {
                var result = validator.validate("")
                expect(result.isValid).to(beFalse())
                expect(result.errors.count) == 1
                
                result = validator.validate("aTextWithMoreThan 10")
                expect(result.isValid).to(beFalse())
                expect(result.errors.count) == 1
                
                result = validator.validate("substring")
                expect(result.isValid).to(beFalse())
                expect(result.errors.count) == 1
            }
            
            it("returns two errors if two validators doesn't pass") {
                let result = validator.validate("this is a text with many substrings")
                expect(result.isValid).to(beFalse())
                expect(result.errors.count) == 2
            }
            
            context("when adding a new validator") {
                
                beforeEach() {
                    validator = validator.addValidator(AnyTextInputValidator { text in
                        var errors: [String] = []
                        if text.contains("AA") {
                            errors.append("The text has 'AA' in it")
                        }
                        if text.contains("BB") {
                            errors.append("The text has 'BB' in it")
                        }
                        if errors == [] {
                            return .valid
                        } else {
                            return .invalid(errors: errors)
                        }
                        })
                    
                }
                
                it("mantains old validators when adding new one") {
                    var result = validator.validate("")
                    expect(result.isValid).to(beFalse())
                    expect(result.errors.count) == 1
                    
                    result = validator.validate("aTextWithMoreThan 10")
                    expect(result.isValid).to(beFalse())
                    expect(result.errors.count) == 1
                    
                    result = validator.validate("substring")
                    expect(result.isValid).to(beFalse())
                    expect(result.errors.count) == 1
                }
                
                it("considers when the new one fails") {
                    let result = validator.validate("AA and BB")
                    expect(result.isValid).to(beFalse())
                    expect(result.errors.count) == 2
                }
                
                it("accepts a text that accomplish all criterias") {
                    let result = validator.validate("This text")
                    expect(result.isValid).to(beTrue())
                    expect(result.errors.count) == 0
                }
                
            }
            
        }
        
    }
    
}
