//
//  LoginController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Rex
import enum Result.NoError

/**
    Log In View Controller that takes care of managing the login, from
    validating email and password fields, to binding a login view to the
    view model and infoming a log in controller delegate when certain 
    events occur for it to act upon them.
 */
public final class LoginController: UIViewController {
    
    typealias LoginErrorHandler = (SessionServiceError, LoginController) -> ()
    
    private let _viewModel: LoginViewModelType
    private let _onRegister: (LoginController) -> ()
    private let _loginViewFactory: () -> LoginViewType
    private let _delegate: LoginControllerDelegateType

    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    /**
        Initializes a login controller with the view model, delegate,
        a factory method for the login view and onRegister closure to use.
     
        - Params:
            - viewModel: view model to bind to and use.
            - loginViewFactory: factory method to call only once
            to get the login view to use.
            - onRegister: closure which indicates what to do when
            the user selects the Register/SignUp option.
            - delegate: delegate which adds behaviour to certain
            events, like handling a login error or selecting log in option.
            A default delegate is provided.
     
        - Returns: A valid login view controller ready to use.
     
    */
    init(viewModel: LoginViewModelType,
        loginViewFactory: () -> LoginViewType,
        onRegister: (LoginController) -> (),
        delegate: LoginControllerDelegateType = DefaultLoginControllerDelegate()) {
            _viewModel = viewModel
            _loginViewFactory = loginViewFactory
            _onRegister = onRegister
            _delegate = delegate
            super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        self.view = loginView.view
    }

    
    override public func viewDidLoad() {
        loginView.render()
        bindViewModel()
    }
    
}

private extension LoginController {
    
    func bindViewModel() {
        
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        
        
        _viewModel.logInExecuting.observeNext { [unowned self] executing in
            if executing {
                self._delegate.loginControllerWillExecuteLogIn(self)
            } else {
                self._delegate.loginControllerDidExecuteLogIn(self)
            }
        }
        
        _viewModel.logInErrors.observeNext { [unowned self] in self._delegate.loginController(self, didLogInWithError: $0) }
        
    }
    
    func bindEmailElements() {
        _viewModel.email <~ loginView.emailTextField.rex_textSignal
        loginView.emailLabel.text = _viewModel.emailText
        loginView.emailTextField.placeholder = _viewModel.emailPlaceholderText
        if let emailValidationMessageLabel = loginView.emailValidationMessageLabel {
            emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? " " }
        }
    }
    
    func bindPasswordElements() {
        _viewModel.password <~ loginView.passwordTextField.rex_textSignal
        loginView.passwordLabel.text = _viewModel.passwordText
        loginView.passwordTextField.placeholder = _viewModel.passwordPlaceholderText
        //loginView.passwordTextField.secureTextEntry = !_viewModel.showPassword.value    // initial value may be required, check with tests
        if let passwordValidationMessageLabel = loginView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        if let passwordVisibilityButton = loginView.passwordVisibilityButton {
            //passwordVisibilityButton.setTitle(_viewModel.passwordVisibilityButtonTitle, forState: .Normal)  // initial value may be required, check with tests
            passwordVisibilityButton.rex_title <~ _viewModel.showPassword.producer.map { [unowned self] _ in
                self._viewModel.passwordVisibilityButtonTitle
            }
            passwordVisibilityButton.rex_pressed.value = _viewModel.togglePasswordVisibility.unsafeCocoaAction
            _viewModel.showPassword.signal.observeNext { [unowned self] showPassword in
                self.loginView.passwordTextField.secureTextEntry = !showPassword
            }
        }
    }
    
    func bindButtons() {
        loginView.logInButton.setTitle(_viewModel.loginButtonTitle, forState: .Normal)
        loginView.logInButton.rex_pressed.value = _viewModel.logInCocoaAction
        
        loginView.registerButton.setTitle(_viewModel.registerButtonTitle, forState: .Normal)
        loginView.registerButton.setAction { [unowned self] _ in self._onRegister(self) }
        
        // loginView.termsAndService -> Present modally web view controller that shows HTML file
        loginView.termsAndService?.setTitle(_viewModel.termsAndServicesButtonTitle, forState: .Normal)
    }
    
}

public extension SessionServiceError {
    var message: String {
        switch self {
        case .InexistentUser:
            return "login-error.inexistent-user.message".localized
        case .WrongPassword:
            return "login-error.wrong-password.message".localized
        case .NetworkError(_):
            return "NETWORK ERROR" //Debería sacar el mensaje del error
        }
    }
}
