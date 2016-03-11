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


struct MyUser: UserType {
    let email: Email
    let name: String
    let password: String
    
    init(email: Email, password: String, name: String) {
        self.email = email
        self.name = name
        self.password = password
    }
}

final class OneMyUserSessionService: SessionServiceType {
    
    private let _possibleUser: MyUser
    private let (_currentUser, _currentUserObserver) = Signal<MyUser, NoError>.pipe()
    
    let currentUser: AnyProperty<MyUser?>
    
    let events: Signal<SessionServiceEvent<MyUser>, NoError>
    private let _observer: Signal<SessionServiceEvent<MyUser>, NoError>.Observer
    
    init(email: Email, password: String, name: String) {
        _possibleUser = User(email: email, password: password, name: name)
        currentUser = AnyProperty(initialValue: Optional.None, signal: _currentUser.map { $0 })
        (events, _observer) = Signal<SessionServiceEvent<User>, NoError>.pipe()
    }
    
    func login(email: Email, _ password: String) -> SignalProducer<MyUser, SessionServiceError> {
        if email == self._possibleUser.email {
            if password == self._possibleUser.password {
                return SignalProducer(value: self._possibleUser).on(completed: {
                    self._observer.sendNext(.LogIn(self._possibleUser))
                    self._currentUserObserver.sendNext(self._possibleUser)
                })
            } else {
                return SignalProducer(error: .WrongPassword)
            }
        } else {
            return SignalProducer(error: .InexistentUser)
        }
    }
    
}


class LogInViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("LogInViewModel") {
            
            let sessionService = OneMyUserSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
            let logInVM = LogInViewModel(sessionService: sessionService)
            
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
                        logInVM.email.value = "my"
                        logInVM.email.value = ""
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
                
                
            }
            
            context("fill password with invalid password") {
                
                context("password shorter than expected") {
                    
                    beforeEach() {
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
                        logInVM.logInCocoaAction.execute(.None)
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
                    }}
                    
                }
                
                context("correct email, wrong password") {
                    
                    beforeEach() {
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
                        logInVM.logInCocoaAction.execute(.None)
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
                    }}
                    
                }
                
                context("wrong email, correct password") {
                    
                    beforeEach() {
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
                        logInVM.logInCocoaAction.execute(.None)
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
                    }}
                    
                }
                
                context("correct email, correct password") {
                    
                    beforeEach() {
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
                        logInVM.logInCocoaAction.execute(.None)
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
                    }}
                    
                }
                
            }
            
            
        }
    }
    
}
