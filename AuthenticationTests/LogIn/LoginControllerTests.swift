//
//  LogInControllerTests.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/14/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Quick
import Nimble
@testable import Authentication
import UIKit

import ReactiveCocoa
import enum Result.NoError
import Rex

class LoginViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("LoginViewController") {
            
            var sessionService: MockSessionService!
            var loginVM: LoginViewModelType!
            var loginV: LoginViewType!
            var loginC: LoginController!
            
            beforeEach() {
                sessionService = MockSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
                loginVM = LoginViewModel(sessionService: sessionService)
                loginV = LoginView()
                let configuration = LoginControllerConfiguration(viewModel: loginVM, viewFactory: { return loginV }, transitionDelegate: MockLoginTransitionDelegate())
                loginC = LoginController(configuration: configuration)
                loginC.viewDidLoad()
            }
            
            afterEach() {
                expect(loginC).to(beNil(), description: "Retain cycle detected in LoginController")
            }
            
            /*
            it("basic example") {
                let button = UIButton(frame: CGRectZero)
                button.enabled = true
                button.userInteractionEnabled = true
                
                let passed = MutableProperty(false)
                let action = Action<(), Bool, NoError> { _ in
                    SignalProducer(value: true)
                }
                
                passed <~ SignalProducer(signal: action.values)
                button.rex_pressed <~ SignalProducer(value: CocoaAction(action, input: ()))
                
                button.sendActionsForControlEvents(.TouchUpInside)
                
                expect(passed.value).toEventually(beTrue())
            }
            
            describe("PasswordVisibility") {
                
                beforeEach() {
                    sessionService = OneMyUserSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
                    loginVM = LoginViewModel(sessionService: sessionService)
                    loginV = LoginView()
                    loginC = LoginController(viewModel: loginVM, loginViewFactory: { return loginV }, onRegister: { _ in }, onLoginError: .None)
                    loginC.viewDidLoad()
                    loginV.passwordVisibilityButton!.enabled = true
                    loginV.passwordVisibilityButton!.userInteractionEnabled = true
                }
                
                it("should start hidden") {
                    expect(loginVM.showPassword.value) == false
                    expect(loginV.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.true".localized
                    expect(loginV.passwordTextField.secureTextEntry) == true
                }
                
                it("should show password when button pressed") {
                    loginV.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    expect(loginVM.showPassword.value).toEventually(beTrue())
                    expect(loginV.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.false".localized
                    expect(loginV.passwordTextField.secureTextEntry) == false
                }
                
                it("should hide password when button pressed again") {
                    loginV.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    loginV.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    expect(loginVM.showPassword.value) == false
                    expect(loginV.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.true".localized
                    expect(loginV.passwordTextField.secureTextEntry) == true                }
                
            }
            
            describe("Email errors") {
                
                it("should show the first of the email errors when email is invalid") {
                    loginV.emailTextField.text = "email"
                    expect(loginV.emailValidationMessageLabel!.text).toEventually(equal("text-input-validator.invalid-email".localized("email")))
                }
                
            }
            */
        }
    }
    
}
