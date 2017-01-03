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
            var loginViewModel: LoginViewModel<MyUser, MockSessionService>!
            
            beforeEach() {
                sessionService = MockSessionService()
                loginViewModel = LoginViewModel(sessionService: sessionService)
            }
            
            it("starts without errors") {
                expect(loginViewModel.emailValidationErrors.value) == []
                expect(loginViewModel.passwordValidationErrors.value) == []
            }
            
            it("starts without showing password") {
                expect(loginViewModel.passwordVisible.value) == false
            }
            
            describe("#togglePasswordVisibility") {
                
                context("when #passwordVisible is false") {
                    
                    it("should change it to true") { waitUntil { done in
                        loginViewModel.passwordVisible.signal.take(first: 1).observeValues {
                            expect($0) == true
                            done()
                        }
                        loginViewModel.togglePasswordVisibility.execute(UIButton())
                    }}
                }
                
                context("when #passwordVisible is true") {
                    
                    beforeEach() {
                        loginViewModel.togglePasswordVisibility.execute(UIButton())
                    }
                    
                    it("should change it to false") { waitUntil { done in
                        loginViewModel.passwordVisible.signal.take(first: 1).observeValues {
                            expect($0) == false
                            done()
                        }
                        loginViewModel.togglePasswordVisibility.execute(UIButton())
                    }}
                    
                }
                
            }
            
            context("when filling email with invalid email") {
                
                context("when email doesn't have @ character") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "my"
                    }
                    
                    it("has one email error") {
                        expect(loginViewModel.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no password errors") {
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == false
                    }
                    
                }
                
                context("when email is empty") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "my"
                        loginViewModel.email.value = ""
                    }
                    
                    it("has two email error - empty and not valid") {
                        expect(loginViewModel.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("has no password errors") {
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == false
                    }
                    
                }
                
                
            }
            
            context("when filling password with invalid password") {
                
                context("when password is shorter than expected") {
                    
                    beforeEach() {
                        loginViewModel.password.value = "my"
                    }
                    
                    it("has one password error") {
                        expect(loginViewModel.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == false
                    }
                    
                }
                
                context("when password is longer than expected") {
                    
                    beforeEach() {
                        loginViewModel.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                    }
                    
                    it("has one password error") {
                        expect(loginViewModel.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == false
                    }
                    
                }
                
                context("when password is empty") {
                    
                    beforeEach() {
                        loginViewModel.password.value = "my"
                        loginViewModel.password.value = ""
                    }
                    
                    it("has two password errors - empty and short") {
                        expect(loginViewModel.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("has no email errors") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                    }
                    
                    it("does not let logIn start") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == false
                    }
                    
                }
                
            }
            
            context("when filling with valid email and password") {
                
                context("when email and password are wrong") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "wrong@email.com"
                        loginViewModel.password.value = "wrongPassword"
                    }
                    
                    it("has no errors at all") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeValues { _ in done() }
                        loginViewModel.logInCocoaAction.execute(UIButton())
                    }}
                    
                }
                
                context("when email is correct but password is wrong") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "myuser@mail.com"
                        loginViewModel.password.value = "wrongPassword"
                    }
                    
                    it("has no errors at all") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeValues { _ in done() }
                        loginViewModel.logInCocoaAction.execute(UIButton())
                    }}
                    
                }
                
                context("when email is wrong and password is correct") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "wrong@email.com"
                        loginViewModel.password.value = "password"
                    }
                    
                    it("has no errors at all") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeValues { _ in done() }
                        loginViewModel.logInCocoaAction.execute(UIButton())
                    }}
                    
                }
                
                context("when email and password are correct") {
                    
                    beforeEach() {
                        loginViewModel.email.value = "myuser@mail.com"
                        loginViewModel.password.value = "password"
                    }
                    
                    it("has no errors at all") {
                        expect(loginViewModel.emailValidationErrors.value) == []
                        expect(loginViewModel.passwordValidationErrors.value) == []
                    }
                    
                    it("enables LogIn") {
                        expect(loginViewModel.logInCocoaAction.isEnabled.value) == true
                    }
                    
                    it("calls session service's signup") { waitUntil { done in
                        sessionService.logInCalled.observeValues { _ in done() }
                        loginViewModel.logInCocoaAction.execute(UIButton())
                    }}
                    
                }
                
            }
            
        }
    }
    
}
