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
            
            var sessionService: OneMyUserSessionService!
            var loginVM: LoginViewModel<MyUser, OneMyUserSessionService>!
            
            beforeEach() {
                sessionService = OneMyUserSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
                loginVM = LoginViewModel(sessionService: sessionService)
            }
            
            it("should start without errors") {
                expect(loginVM.emailValidationErrors.value) == []
                expect(loginVM.passwordValidationErrors.value) == []
            }
            
            it("should start without showing password") {
                expect(loginVM.showPassword.value) == false
            }
            
            context("fill email with invalid email") {
                
                context("email without @ character") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "my"
                    }
                    
                    it("should have one email error") {
                        expect(loginVM.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no password errors") {
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("empty") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "my"
                        loginVM.email.value = ""
                    }
                    
                    it("should have two email error - empty and not valid") {
                        expect(loginVM.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("should have no password errors") {
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                
            }
            
            context("fill password with invalid password") {
                
                context("password shorter than expected") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.password.value = "my"
                    }
                    
                    it("should have one password error") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("password longer than expected") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                    }
                    
                    it("should have one password error") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("empty password") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.password.value = "my"
                        loginVM.password.value = ""
                    }
                    
                    it("should have two password errors - empty and short") {
                        expect(loginVM.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(loginVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(loginVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
            }
            
            context("fill with valid email and password") {
                
                context("wrong email, wrong password") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "wrong@email.com"
                        loginVM.password.value = "wrongPassword"
                    }
                    
                    it("should have no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("should return logIn email error") { waitUntil { done in
                        sessionService.events.observeNext { event in
                            switch event {
                            case .LogInError(let error):
                                switch error {
                                case .InexistentUser:
                                    done()
                                default: break
                                }
                            default: break
                            }
                        }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("correct email, wrong password") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "myuser@mail.com"
                        loginVM.password.value = "wrongPassword"
                    }
                    
                    it("should have no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("should return logIn password error") { waitUntil { done in
                        sessionService.events.observeNext { event in
                            switch event {
                            case .LogInError(let error):
                                switch error {
                                case .WrongPassword:
                                    done()
                                default: break
                                }
                            default: break
                            }
                        }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("wrong email, correct password") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "wrong@email.com"
                        loginVM.password.value = "password"
                    }
                    
                    it("should have no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("should return logIn email error") { waitUntil { done in
                        sessionService.events.observeNext { event in
                            switch event {
                            case .LogInError(let error):
                                switch error {
                                case .InexistentUser:
                                    done()
                                default: break
                                }
                            default: break
                            }
                        }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("correct email, correct password") {
                    
                    beforeEach() {
                        loginVM = LoginViewModel(sessionService: sessionService)
                        loginVM.email.value = "myuser@mail.com"
                        loginVM.password.value = "password"
                    }
                    
                    it("should have no errors at all") {
                        expect(loginVM.emailValidationErrors.value) == []
                        expect(loginVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(loginVM.logInCocoaAction.enabled) == true
                    }
                    
                    it("should return logInUser") { waitUntil { done in
                        sessionService.events.observeNext { event in
                            switch event {
                            case .LogIn(let user):
                                expect(user.email.raw) == "myuser@mail.com"
                                expect(user.password) == "password"
                                expect(user.name) == "MyUser"
                                done()
                            default: break
                            }
                        }
                        loginVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
            }
            
            
        }
    }
    
}
