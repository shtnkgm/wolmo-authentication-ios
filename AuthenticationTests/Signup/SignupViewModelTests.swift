//
//  SignupViewModelTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/27/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

import ReactiveCocoa
import enum Result.NoError


class SignupViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("SignupViewModel") {
            
            let validEmail = "example@mail.com"
            let validPassword = "password"
            let invalidPassword = "pass"
            let validUsername = "username"
            let invalidUsername = ""
            
            var sessionService: MockSessionService!
            var signupVM: SignupViewModel<MyUser, MockSessionService>!
            
            beforeEach() {
                sessionService = MockSessionService()
                signupVM = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: false, usernameEnabled: false)
            }
            
            it("starts without errors") {
                expect(signupVM.usernameValidationErrors.value) == []
                expect(signupVM.emailValidationErrors.value) == []
                expect(signupVM.passwordValidationErrors.value) == []
                expect(signupVM.passwordConfirmationValidationErrors.value) == []
            }
            
            it("starts without showing password") {
                expect(signupVM.passwordVisible.value) == false
                expect(signupVM.passwordConfirmationVisible.value) == false
            }
            
            describe("#togglePasswordVisibility") {
                
                context("when executing action") {
                    
                    it("should change #passwordVisible from false to true") { waitUntil { done in
                        signupVM.passwordVisible.signal.take(1).observeNext {
                            expect($0) == true
                            done()
                        }
                        signupVM.togglePasswordVisibility.execute("")
                    }}
                    
                    it("should change #passwordVisible from true to false") { waitUntil { done in
                        signupVM.passwordVisible.signal.take(2).skip(1).observeNext {
                            expect($0) == false
                            done()
                        }
                        signupVM.togglePasswordVisibility.execute("")
                        signupVM.togglePasswordVisibility.execute("")
                    }}
                    
                }
                
            }
            
            describe("#togglePasswordConfirmVisibility") {
                
                context("when executing action") {
                    
                    it("should change #passwordConfirmationVisible from false to true") { waitUntil { done in
                        signupVM.passwordConfirmationVisible.signal.take(1).observeNext {
                            expect($0) == true
                            done()
                        }
                        signupVM.togglePasswordConfirmVisibility.execute("")
                    }}
                    
                    it("should change #passwordConfirmationVisible from true to false") { waitUntil { done in
                        signupVM.passwordConfirmationVisible.signal.take(2).skip(1).observeNext {
                            expect($0) == false
                            done()
                        }
                        signupVM.togglePasswordConfirmVisibility.execute("")
                        signupVM.togglePasswordConfirmVisibility.execute("")
                    }}
                    
                }
                
            }
            
            context("when username and password confirmation disabled") {
                
                context("when filling email with invalid email") {
                    
                    context("when email doesn't have @ character") {
                        
                        beforeEach() {
                            signupVM.email.value = "my"
                        }
                        
                        it("has one email error") {
                            expect(signupVM.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no password errors") {
                            expect(signupVM.passwordValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when email is empty") {
                        
                        beforeEach() {
                            signupVM.email.value = "my"
                            signupVM.email.value = ""
                        }
                        
                        it("has two email error - empty and not valid") {
                            expect(signupVM.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                        }
                        
                        it("has no password errors") {
                            expect(signupVM.passwordValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
                context("when filling password with invalid password") {
                    
                    context("when password is shorter than expected") {
                        
                        beforeEach() {
                            signupVM.password.value = "my"
                        }
                        
                        it("has one password error") {
                            expect(signupVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupVM.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when password is longer than expected") {
                        
                        beforeEach() {
                            signupVM.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                        }
                        
                        it("has one password error") {
                            expect(signupVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupVM.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when password is empty") {
                        
                        beforeEach() {
                            signupVM.password.value = "my"
                            signupVM.password.value = ""
                        }
                        
                        it("has two password errors - empty and short") {
                            expect(signupVM.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupVM.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
                context("when filling with valid email and password") {
                    
                    beforeEach() {
                        signupVM.email.value = validEmail
                        signupVM.password.value = validPassword
                    }
                    
                    it("has no errors at all") {
                        expect(signupVM.emailValidationErrors.value) == []
                        expect(signupVM.passwordValidationErrors.value) == []
                    }
                    
                    it("enables signUp") {
                        expect(signupVM.signUpCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.signUpCalled.take(1).observeNext { _ in done() }
                        signupVM.signUpCocoaAction.execute("")
                    }}
                    
                }
            }
            
            context("when username enabled and password confirmation disabled") {
                
                beforeEach() {
                    signupVM = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: false, usernameEnabled: true)
                }
                
                context("when email and password are valid") {
                    
                    beforeEach() {
                        signupVM.email.value = validEmail
                        signupVM.password.value = validPassword
                    }
                    
                    context("when username is valid") {
                        
                        beforeEach() {
                            signupVM.username.value = validUsername
                        }
                        
                        it("has no errors at all") {
                            expect(signupVM.usernameValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupVM.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupVM.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                    context("when username is invalid") {
                        
                        beforeEach() {
                            signupVM.username.value = invalidUsername
                        }
                        
                        it("has one username error - empty") {
                            expect(signupVM.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
            }
            
            context("when password confirmation enabled and username disabled") {
                
                beforeEach() {
                    signupVM = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: true, usernameEnabled: false)
                }
                
                context("when email and password valid") {
                    
                    beforeEach() {
                        signupVM.email.value = validEmail
                        signupVM.password.value = validPassword
                    }
                    
                    context("when password confirmation is valid") {
                        
                        beforeEach() {
                            signupVM.passwordConfirmation.value = validPassword
                        }
                        
                        it("has no errors at all") {
                            expect(signupVM.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupVM.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupVM.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                    context("when password confirmation is invalid") {
                        
                        beforeEach() {
                            signupVM.passwordConfirmation.value = invalidPassword
                        }
                        
                        it("has one password confirmation error - not matching") {
                            expect(signupVM.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
            }
            
            context("when username and password confirmation enabled") {
                
                beforeEach() {
                    signupVM = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: true, usernameEnabled: true)
                }
                
                context("when email and password valid") {
                    
                    beforeEach() {
                        signupVM.email.value = "myuser@mail.com"
                        signupVM.password.value = "password"
                    }
                    
                    context("when username invalid and password confirmation valid") {
                        
                        beforeEach() {
                            signupVM.username.value = ""
                            signupVM.passwordConfirmation.value = "password"
                        }
                        
                        it("has one username error - empty") {
                            expect(signupVM.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no password confirmation errors") {
                            expect(signupVM.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username valid and password confirmation invalid") {
                        
                        beforeEach() {
                            signupVM.username.value = "username"
                            signupVM.passwordConfirmation.value = "pass"
                        }
                        
                        it("has one password confirmation error - empty") {
                            expect(signupVM.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no username errors") {
                            expect(signupVM.usernameValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username and password confirmation invalid") {
                        
                        beforeEach() {
                            signupVM.username.value = ""
                            signupVM.passwordConfirmation.value = "pass"
                        }
                        
                        it("has one username error - empty") {
                            expect(signupVM.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has one password confirmation error - empty") {
                            expect(signupVM.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupVM.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username and password confirmation valid") {
                        
                        beforeEach() {
                            signupVM.username.value = "username"
                            signupVM.passwordConfirmation.value = "password"
                        }
                        
                        it("has no errors at all") {
                            expect(signupVM.usernameValidationErrors.value) == []
                            expect(signupVM.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupVM.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupVM.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}
