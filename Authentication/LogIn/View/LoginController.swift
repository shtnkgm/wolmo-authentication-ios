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
    
    typealias LogInErrorHandler = (SessionServiceError, LoginController) -> ()
    
    private let _viewModel: LoginViewModelType
    private let _onLogInError: LogInErrorHandler?
    private let _onRegister: (LoginController) -> ()
    
    private let _loginViewFactory: () -> LoginViewType
    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    init(viewModel: LoginViewModelType,
        loginViewFactory: () -> LoginViewType,
        onRegister: (LoginController) -> (),
        onLogInError: LogInErrorHandler? = Optional.None) {
            _viewModel = viewModel
            _onLogInError = onLogInError
            _onRegister = onRegister
            self._loginViewFactory = loginViewFactory
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
            if let logInErrorLabel = self.loginView.loginErrorLabel {
                logInErrorLabel.text = error.message
            } else if let onLogInError = self._onLogInError {
                onLogInError(error, self)
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
        if let passwordValidationMessageLabel = loginView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        if let passwordVisibilityButton = loginView.passwordVisibilityButton {
            passwordVisibilityButton.rex_pressed.value = _viewModel.togglePasswordVisibility.unsafeCocoaAction
            _viewModel.showPassword.signal.observeNext { [unowned self] showPassword in
                passwordVisibilityButton.setTitle(self._viewModel.passwordVisibilityButtonTitle, forState: .Normal)
                self.loginView.passwordTextField.secureTextEntry = !showPassword
            }
        }
    }
    
    func bindButtons() {
        loginView.loginButton.setTitle(_viewModel.loginButtonTitle, forState: .Normal)
        loginView.loginButton.rex_pressed.value = _viewModel.logInCocoaAction
        
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
