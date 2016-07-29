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
            var signupViewModel: SignupViewModel<MyUser, MockSessionService>!
            
            beforeEach() {
                sessionService = MockSessionService()
                signupViewModel = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: false, usernameEnabled: false)
            }
            
            it("starts without errors") {
                expect(signupViewModel.usernameValidationErrors.value) == []
                expect(signupViewModel.emailValidationErrors.value) == []
                expect(signupViewModel.passwordValidationErrors.value) == []
                expect(signupViewModel.passwordConfirmationValidationErrors.value) == []
            }
            
            it("starts without showing password") {
                expect(signupViewModel.passwordVisible.value) == false
                expect(signupViewModel.passwordConfirmationVisible.value) == false
            }
            
            describe("#togglePasswordVisibility") {
                
                context("when executing action") {
                    
                    it("should change #passwordVisible from false to true") { waitUntil { done in
                        signupViewModel.passwordVisible.signal.take(1).observeNext {
                            expect($0) == true
                            done()
                        }
                        signupViewModel.togglePasswordVisibility.execute("")
                    }}
                    
                    it("should change #passwordVisible from true to false") { waitUntil { done in
                        signupViewModel.passwordVisible.signal.take(2).skip(1).observeNext {
                            expect($0) == false
                            done()
                        }
                        signupViewModel.togglePasswordVisibility.execute("")
                        signupViewModel.togglePasswordVisibility.execute("")
                    }}
                    
                }
                
            }
            
            describe("#togglePasswordConfirmVisibility") {
                
                context("when executing action") {
                    
                    it("should change #passwordConfirmationVisible from false to true") { waitUntil { done in
                        signupViewModel.passwordConfirmationVisible.signal.take(1).observeNext {
                            expect($0) == true
                            done()
                        }
                        signupViewModel.togglePasswordConfirmVisibility.execute("")
                    }}
                    
                    it("should change #passwordConfirmationVisible from true to false") { waitUntil { done in
                        signupViewModel.passwordConfirmationVisible.signal.take(2).skip(1).observeNext {
                            expect($0) == false
                            done()
                        }
                        signupViewModel.togglePasswordConfirmVisibility.execute("")
                        signupViewModel.togglePasswordConfirmVisibility.execute("")
                    }}
                    
                }
                
            }
            
            context("when username and password confirmation disabled") {
                
                context("when filling email with invalid email") {
                    
                    context("when email doesn't have @ character") {
                        
                        beforeEach() {
                            signupViewModel.email.value = "my"
                        }
                        
                        it("has one email error") {
                            expect(signupViewModel.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no password errors") {
                            expect(signupViewModel.passwordValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when email is empty") {
                        
                        beforeEach() {
                            signupViewModel.email.value = "my"
                            signupViewModel.email.value = ""
                        }
                        
                        it("has two email error - empty and not valid") {
                            expect(signupViewModel.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                        }
                        
                        it("has no password errors") {
                            expect(signupViewModel.passwordValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
                context("when filling password with invalid password") {
                    
                    context("when password is shorter than expected") {
                        
                        beforeEach() {
                            signupViewModel.password.value = "my"
                        }
                        
                        it("has one password error") {
                            expect(signupViewModel.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupViewModel.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when password is longer than expected") {
                        
                        beforeEach() {
                            signupViewModel.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                        }
                        
                        it("has one password error") {
                            expect(signupViewModel.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupViewModel.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when password is empty") {
                        
                        beforeEach() {
                            signupViewModel.password.value = "my"
                            signupViewModel.password.value = ""
                        }
                        
                        it("has two password errors - empty and short") {
                            expect(signupViewModel.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                        }
                        
                        it("has no email errors") {
                            expect(signupViewModel.emailValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
                context("when filling with valid email and password") {
                    
                    beforeEach() {
                        signupViewModel.email.value = validEmail
                        signupViewModel.password.value = validPassword
                    }
                    
                    it("has no errors at all") {
                        expect(signupViewModel.emailValidationErrors.value) == []
                        expect(signupViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("enables signUp") {
                        expect(signupViewModel.signUpCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.signUpCalled.take(1).observeNext { _ in done() }
                        signupViewModel.signUpCocoaAction.execute("")
                    }}
                    
                }
            }
            
            context("when username enabled and password confirmation disabled") {
                
                beforeEach() {
                    signupViewModel = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: false, usernameEnabled: true)
                }
                
                context("when email and password are valid") {
                    
                    beforeEach() {
                        signupViewModel.email.value = validEmail
                        signupViewModel.password.value = validPassword
                    }
                    
                    context("when username is valid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = validUsername
                        }
                        
                        it("has no errors at all") {
                            expect(signupViewModel.usernameValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupViewModel.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                    context("when username is invalid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = invalidUsername
                        }
                        
                        it("has one username error - empty") {
                            expect(signupViewModel.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
            }
            
            context("when password confirmation enabled and username disabled") {
                
                beforeEach() {
                    signupViewModel = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: true, usernameEnabled: false)
                }
                
                context("when email and password valid") {
                    
                    beforeEach() {
                        signupViewModel.email.value = validEmail
                        signupViewModel.password.value = validPassword
                    }
                    
                    context("when password confirmation is valid") {
                        
                        beforeEach() {
                            signupViewModel.passwordConfirmation.value = validPassword
                        }
                        
                        it("has no errors at all") {
                            expect(signupViewModel.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupViewModel.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                    context("when password confirmation is invalid") {
                        
                        beforeEach() {
                            signupViewModel.passwordConfirmation.value = invalidPassword
                        }
                        
                        it("has one password confirmation error - not matching") {
                            expect(signupViewModel.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                }
                
            }
            
            context("when username and password confirmation enabled") {
                
                beforeEach() {
                    signupViewModel = SignupViewModel(sessionService: sessionService, passwordConfirmationEnabled: true, usernameEnabled: true)
                }
                
                context("when email and password valid") {
                    
                    beforeEach() {
                        signupViewModel.email.value = "myuser@mail.com"
                        signupViewModel.password.value = "password"
                    }
                    
                    context("when username invalid and password confirmation valid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = ""
                            signupViewModel.passwordConfirmation.value = "password"
                        }
                        
                        it("has one username error - empty") {
                            expect(signupViewModel.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no password confirmation errors") {
                            expect(signupViewModel.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username valid and password confirmation invalid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = "username"
                            signupViewModel.passwordConfirmation.value = "pass"
                        }
                        
                        it("has one password confirmation error - empty") {
                            expect(signupViewModel.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has no name errors") {
                            expect(signupViewModel.usernameValidationErrors.value) == []
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username and password confirmation invalid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = ""
                            signupViewModel.passwordConfirmation.value = "pass"
                        }
                        
                        it("has one username error - empty") {
                            expect(signupViewModel.usernameValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("has one password confirmation error - empty") {
                            expect(signupViewModel.passwordConfirmationValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                        }
                        
                        it("does not let signUp start") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == false
                        }
                        
                    }
                    
                    context("when username and password confirmation valid") {
                        
                        beforeEach() {
                            signupViewModel.username.value = "username"
                            signupViewModel.passwordConfirmation.value = "password"
                        }
                        
                        it("has no errors at all") {
                            expect(signupViewModel.usernameValidationErrors.value) == []
                            expect(signupViewModel.passwordConfirmationValidationErrors.value) == []
                        }
                        
                        it("enables signUp") {
                            expect(signupViewModel.signUpCocoaAction.enabled) == true
                        }
                        
                        it("calls session service's signup") { waitUntil { done in
                            sessionService.signUpCalled.take(1).observeNext { _ in done() }
                            signupViewModel.signUpCocoaAction.execute("")
                        }}
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}
