//
//  ValidatorsTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/14/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication


class ValidatorsSpec: QuickSpec {
    
    override func spec() {
        
        var validator: TextInputValidatorType!
        
        describe("EmailValidator") {
            
            beforeEach() {
                validator = EmailValidator()
            }
            
            it("should not accept an email without @") {
                expect(validator.validate("email").isValid).to(beFalse())
            }
            
            it("should accept any email with @") {
                expect(validator.validate("@email").isValid).to(beTrue())
            }
        
        }
        
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
        
        describe("MaxLengthValidator") {
            
            beforeEach() {
                validator = MaxLengthValidator(maxLength: 6)
            }
            
            it("should not accept a text longer than 6") {
                expect(validator.validate("this is a long text").isValid).to(beFalse())
            }
            
            it("should accept any text shorter than 6") {
                expect(validator.validate("").isValid).to(beTrue())
            }
            
            it("should accept any text of length 6") {
                expect(validator.validate("123456").isValid).to(beTrue())
            }
            
        }
        
        describe("MinLengthValidator") {
            
            beforeEach() {
                validator = MinLengthValidator(minLength: 3)
            }
            
            it("should not accept a text shorter than 3") {
                expect(validator.validate("ab").isValid).to(beFalse())
            }
            
            it("should accept any text longer than 3") {
                expect(validator.validate("text").isValid).to(beTrue())
            }
            
            it("should accept any text of length 3") {
                expect(validator.validate("123").isValid).to(beTrue())
            }
            
        }
        
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
            
            it("should not accept a text which isn't what expected") {
                expect(validator.validate("email").isValid).to(beFalse())
            }
            
            it("should accept a text which is what expected") {
                expect(validator.validate("myText").isValid).to(beTrue())
            }
            
        }
        
        describe("CompositeTextInputValidator") {
            
            beforeEach() {
                validator = CompositeTextInputValidator(validators:
                    [NonEmptyValidator(),
                    AnyTextInputValidator { text in
                        if text.containsString("substring") {
                            return .Invalid(errors: ["The string contains invalid word 'substring'"])
                        } else {
                            return .Valid
                        }
                    },
                    MaxLengthValidator(maxLength: 10)]
                )
            }
            
            it("should return one error if only one validator doesn't pass") {
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
            
            it("should return two errors if two validators doesn't pass") {
                let result = validator.validate("this is a text with many substrings")
                expect(result.isValid).to(beFalse())
                expect(result.errors.count) == 2
            }
            
            context("when adding a new validator") {
                
                beforeEach() {
                    validator = (validator as! CompositeTextInputValidator).addValidator(AnyTextInputValidator { text in
                        var errors: [String] = []
                        if text.containsString("AA") {
                            errors.append("The text has 'AA' in it")
                        }
                        if text.containsString("BB") {
                            errors.append("The text has 'BB' in it")
                        }
                        if errors == [] {
                            return .Valid
                        } else {
                            return .Invalid(errors: errors)
                        }
                    })

                }
                
                it("should mantain old validators when adding new one") {
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

                it("should consider when the new one fails") {
                    let result = validator.validate("AA and BB")
                    expect(result.isValid).to(beFalse())
                    expect(result.errors.count) == 2
                }
                
                it("should accept a text that accomplish all criterias") {
                    let result = validator.validate("This text")
                    expect(result.isValid).to(beTrue())
                    expect(result.errors.count) == 0
                }
                
            }
            
        }
        
    }
}