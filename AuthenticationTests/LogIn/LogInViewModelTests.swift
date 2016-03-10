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
    typealias User = MyUser
    
    private let _possibleUser: User
    private let _currentUser: User?
    let currentUser: AnyProperty<User?>
    
    let events: Signal<SessionServiceEvent<User>, NoError>
    let _observer: Signal<SessionServiceEvent<User>, NoError>.Observer
    
    init(email: Email, password: String, name: String) {
        _possibleUser = User(email: email, password: password, name: name)
        currentUser <~ _currentUser
        (events, _observer) = Signal<SessionServiceEvent<User>, NoError>.pipe()
    }
    
    func login(email: Email, _ password: String) -> SignalProducer<User, SessionServiceError> {
        if email == _possibleUser.email {
            if password == _possibleUser.password {
                _currentUser = _possibleUser
                observer.sendNext(.LogIn(_possibleUser))
                return SignalProducer(value: _possibleUser)
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
            
            let sessionService = OneMyUserSessionService(email: Email("myuser@mail.com")!, password: "password", name: "MyUser")
            let logInVM = LogInViewModel(sessionService: sessionService)
            
            it("should start without errors") {
                expect(logInVM.emailValidationErrors.value) == []
                expect(logInVM.passwordValidationErrors.value) == []
            }
            
            it("should start without showing password") {
                expect(logInVM.showPassword) == false
            }
            
            context("fill email with invalid email") {
                
                context("email without @ character") {
                    
                    beforeEach() {
                        logInVM.email = "my"
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
                        logInVM.email = "my"
                        logInVM.email = ""
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
                        logInVM.password = "my"
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
                        logInVM.password = "myVeryLongPasswordWithMoreThan30Characters"
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
                        logInVM.password = "my"
                        logInVM.password = ""
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
                        logInVM.email = "wrong@email.com"
                        logInVM.password = "wrongPassword"
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
                        logInVM.email = "myuser@mail.com"
                        logInVM.password = "wrongPassword"
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
                        logInVM.email = "wrong@email.com"
                        logInVM.password = "password"
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
                        logInVM.email = "myuser@mail.com"
                        logInVM.password = "password"
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
                                expect(user.email) == Email("myuser@mail.com")!
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
