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
            var loginViewModel: LoginViewModelType!
            var loginView: LoginViewType!
            var loginController: LoginController!
            
            beforeEach() {
                sessionService = MockSessionService(email: Email(raw: "myuser@mail.com")!, password: "password", name: "MyUser")
                loginViewModel = LoginViewModel(sessionService: sessionService)
                loginView = LoginView()
                let configuration = LoginControllerConfiguration(viewModel: loginViewModel, viewFactory: { return loginView }, transitionDelegate: MockLoginTransitionDelegate())
                loginController = LoginController(configuration: configuration)
                loginController.viewDidLoad()
            }
            
            afterEach() {
                expect(loginController).to(beNil(), description: "Retain cycle detected in LoginController")
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
                    loginViewModel = LoginViewModel(sessionService: sessionService)
                    loginView = LoginView()
                    loginController = LoginController(viewModel: loginViewModel, loginViewFactory: { return loginView }, onSignup: { _ in }, onLoginError: .None)
                    loginController.viewDidLoad()
                    loginView.passwordVisibilityButton!.enabled = true
                    loginView.passwordVisibilityButton!.userInteractionEnabled = true
                }
                
                it("should start hidden") {
                    expect(loginViewModel.showPassword.value) == false
                    expect(loginView.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.true".frameworkLocalized
                    expect(loginView.passwordTextField.secureTextEntry) == true
                }
                
                it("should show password when button pressed") {
                    loginView.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    expect(loginViewModel.showPassword.value).toEventually(beTrue())
                    expect(loginView.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.false".frameworkLocalized
                    expect(loginView.passwordTextField.secureTextEntry) == false
                }
                
                it("should hide password when button pressed again") {
                    loginView.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    loginView.passwordVisibilityButton!.sendActionsForControlEvents(.TouchUpInside)
                    expect(loginViewModel.showPassword.value) == false
                    expect(loginView.passwordVisibilityButton!.titleForState(.Normal)) == "password-visibility.button-title.true".frameworkLocalized
                    expect(loginView.passwordTextField.secureTextEntry) == true                }
                
            }
            
            describe("Email errors") {
                
                it("should show the first of the email errors when email is invalid") {
                    loginView.emailTextField.text = "email"
                    expect(loginView.emailValidationMessageLabel!.text).toEventually(equal("text-input-validator.invalid-email".frameworkLocalized("email")))
                }
                
            }
            */
        }
    }
    
}
