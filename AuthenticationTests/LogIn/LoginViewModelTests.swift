//
//  LoginViewModelTests.swift
//  AuthenticationTests
//
//  Created by Guido Marucci Blas on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication

import ReactiveCocoa
import enum Result.NoError


class LoginViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("LoginViewModel") {

            var sessionService: MockSessionService!
            var loginVM: LoginViewModel<MyUser, MockSessionService>!
            
            beforeEach() {
                sessionService = MockSessionService()
                loginVM = LoginViewModel(sessionService: sessionService)
            }
            
            it("starts without errors") {
                expect(loginVM.emailValidationErrors.value) == []
                expect(loginVM.passwordValidationErrors.value) == []
            }
            
            it("starts without showing password") {
                expect(loginVM.passwordVisible.value) == false
            }
            
            describe("#togglePasswordVisibility") {
                
                context("when executing action") {
                    
                    it("should change #passwordVisible from false to true") { waitUntil { done in
                        loginVM.passwordVisible.signal.take(1).observeNext {
                            expect($0) == true
                            done()
                        }
                        loginVM.togglePasswordVisibility.execute("")
                    }}
                    
                    it("should change #passwordVisible from true to false") { waitUntil { done in
                        loginVM.passwordVisible.signal.take(2).skip(1).observeNext {
                            expect($0) == false
                            done()
                        }
                        loginVM.togglePasswordVisibility.execute("")
                        loginVM.togglePasswordVisibility.execute("")
                    }}
                    
                }
                
            }
            
            context("when filling email with invalid email") {
                
                context("when email doesn't have @ character") {
                    
                    beforeEach() {
                        loginVM.email.value = "my"
                    }
                    
                    it("has one email error") {
                        expect(loginVM.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no password errors") {
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("when email is empty") {
                    
                    beforeEach() {
                        loginVM.email.value = "my"
                        loginVM.email.value = ""
                    }
                    
                    it("has two email error - empty and not valid") {
                        expect(loginVM.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("has no password errors") {
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                
            }
            
            context("when filling password with invalid password") {
                
                context("when password is shorter than expected") {
                    
                    beforeEach() {
                        loginVM.password.value = "my"
                    }
                    
                    it("has one password error") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("when password is longer than expected") {
                    
                    beforeEach() {
                        loginVM.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                    }
                    
                    it("has one password error") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("when password is empty") {
                    
                    beforeEach() {
                        loginVM.password.value = "my"
                        loginVM.password.value = ""
                    }
                    
                    it("has two password errors - empty and short") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
            }
            
            context("when filling with valid email and password") {
                
                context("when email and password are wrong") {
                    
                    beforeEach() {
                        loginVM.email.value = "wrong@email.com"
                        loginVM.password.value = "wrongPassword"
                    }
                    
                    it("has no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeNext { _ in done() }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("when email is correct but password is wrong") {
                    
                    beforeEach() {
                        loginVM.email.value = "myuser@mail.com"
                        loginVM.password.value = "wrongPassword"
                    }
                    
                    it("has no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeNext { _ in done() }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("when email is wrong and password is correct") {
                    
                    beforeEach() {
                        loginVM.email.value = "wrong@email.com"
                        loginVM.password.value = "password"
                    }
                    
                    it("has no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeNext { _ in done() }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("when email and password are correct") {
                    
                    beforeEach() {
                        loginVM.email.value = "myuser@mail.com"
                        loginVM.password.value = "password"
                    }
                    
                    it("has no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeNext { _ in done() }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
            }
            
        }
    }
    
}
