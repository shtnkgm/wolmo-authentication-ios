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

*/
public final class LoginController: UIViewController {
    
    typealias LoginErrorHandler = (SessionServiceError, LoginController) -> ()
    
    private let _viewModel: LoginViewModelType
    private let _onLoginError: LoginErrorHandler?
    private let _onRegister: (LoginController) -> ()
    
    private let _loginViewFactory: () -> LoginViewType
    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    init(viewModel: LoginViewModelType,
        loginViewFactory: () -> LoginViewType,
        onRegister: (LoginController) -> (),
        onLoginError: LoginErrorHandler? = Optional.None) {
            _viewModel = viewModel
            _onLoginError = onLoginError
            _onRegister = onRegister
            _loginViewFactory = loginViewFactory
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
                self.loginView.activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            } else {
                self.loginView.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
        
        _viewModel.logInErrors.observeNext { [unowned self] error in
            if let logInErrorLabel = self.loginView.logInErrorLabel {
                logInErrorLabel.text = error.message
            } else if let onLoginError = self._onLoginError {
                onLoginError(error, self)
            } else {
                let alert = UIAlertController(title: "", message: error.message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
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
