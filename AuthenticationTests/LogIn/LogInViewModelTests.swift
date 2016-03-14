//
//  LogInViewModelTests.swift
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


class LogInViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("LogInViewModel") {
            
            var sessionService: OneMyUserSessionService!
            var logInVM: LogInViewModel<MyUser, OneMyUserSessionService>!
            
            beforeEach() {
                sessionService = OneMyUserSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
                logInVM = LogInViewModel(sessionService: sessionService)
            }
            
            it("should start without errors") {
                expect(logInVM.emailValidationErrors.value) == []
                expect(logInVM.passwordValidationErrors.value) == []
            }
            
            it("should start without showing password") {
                expect(logInVM.showPassword.value) == false
            }
            
            context("fill email with invalid email") {
                
                context("email without @ character") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "my"
                    }
                    
                    it("should have one email error") {
                        expect(logInVM.emailValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no password errors") {
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(logInVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("empty") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "my"
                        logInVM.email.value = ""
                    }
                    
                    it("should have two email error - empty and not valid") {
                        expect(logInVM.emailValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("should have no password errors") {
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(logInVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                
            }
            
            context("fill password with invalid password") {
                
                context("password shorter than expected") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.password.value = "my"
                    }
                    
                    it("should have one password error") {
                        expect(logInVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(logInVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(logInVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("password longer than expected") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.password.value = "myVeryLongPasswordWithMoreThan30Characters"
                    }
                    
                    it("should have one password error") {
                        expect(logInVM.passwordValidationErrors.value.count).toEventually(equal(1), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(logInVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(logInVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
                context("empty password") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.password.value = "my"
                        logInVM.password.value = ""
                    }
                    
                    it("should have two password errors - empty and short") {
                        expect(logInVM.passwordValidationErrors.value.count).toEventually(equal(2), timeout: 3)
                    }
                    
                    it("should have no email errors") {
                        expect(logInVM.emailValidationErrors.value) == []
                    }
                    
                    it("should not let logIn start") {
                        expect(logInVM.logInCocoaAction.enabled) == false
                    }
                    
                }
                
            }
            
            context("fill with valid email and password") {
                
                context("wrong email, wrong password") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "wrong@email.com"
                        logInVM.password.value = "wrongPassword"
                    }
                    
                    it("should have no errors at all") {
                        expect(logInVM.emailValidationErrors.value) == []
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(logInVM.logInCocoaAction.enabled) == true
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
                        logInVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("correct email, wrong password") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "myuser@mail.com"
                        logInVM.password.value = "wrongPassword"
                    }
                    
                    it("should have no errors at all") {
                        expect(logInVM.emailValidationErrors.value) == []
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(logInVM.logInCocoaAction.enabled) == true
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
                        logInVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("wrong email, correct password") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "wrong@email.com"
                        logInVM.password.value = "password"
                    }
                    
                    it("should have no errors at all") {
                        expect(logInVM.emailValidationErrors.value) == []
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(logInVM.logInCocoaAction.enabled) == true
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
                        logInVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
                context("correct email, correct password") {
                    
                    beforeEach() {
                        logInVM = LogInViewModel(sessionService: sessionService)
                        logInVM.email.value = "myuser@mail.com"
                        logInVM.password.value = "password"
                    }
                    
                    it("should have no errors at all") {
                        expect(logInVM.emailValidationErrors.value) == []
                        expect(logInVM.passwordValidationErrors.value) == []
                    }
                    
                    it("should enable LogIn") {
                        expect(logInVM.logInCocoaAction.enabled) == true
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
                        logInVM.logInCocoaAction.execute("")
                    }}
                    
                }
                
            }
            
            
        }
    }
    
}
