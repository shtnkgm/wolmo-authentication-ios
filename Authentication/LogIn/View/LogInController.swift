//
//  LogInController.swift
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
public final class LogInController: UIViewController {
    
    typealias LogInErrorHandler = (SessionServiceError, LogInController) -> ()
    
    private let _viewModel: LogInViewModelType
    private let _onLogInError: LogInErrorHandler?
    private let _onRegister: (LogInController) -> ()
    
    private let _logInViewFactory: () -> LogInViewType
    public lazy var logInView: LogInViewType = self._logInViewFactory()
    
    init(viewModel: LogInViewModelType,
        logInViewFactory: () -> LogInViewType,
        onRegister: (LogInController) -> (),
        onLogInError: LogInErrorHandler? = Optional.None) {
            _viewModel = viewModel
            _onLogInError = onLogInError
            _onRegister = onRegister
            self._logInViewFactory = logInViewFactory
            super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        self.view = logInView.view
    }

    
    override public func viewDidLoad() {
        logInView.render()
        bindViewModel()
    }
    
}

private extension LogInController {
    
    func bindViewModel() {
        
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        
        _viewModel.logInExecuting.observeNext { [unowned self] executing in
            if executing {
                self.logInView.activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            } else {
                self.logInView.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
        
        _viewModel.logInErrors.observeNext { [unowned self] error in
            if let logInErrorLabel = self.logInView.loginErrorLabel {
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
        _viewModel.email <~ logInView.emailTextField.rex_textSignal
        logInView.emailLabel.text = _viewModel.emailText
        logInView.emailTextField.placeholder = _viewModel.emailPlaceholderText
        if let emailValidationMessageLabel = logInView.emailValidationMessageLabel {
            emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? " " }
        }
    }
    
    func bindPasswordElements() {
        _viewModel.password <~ logInView.passwordTextField.rex_textSignal
        logInView.passwordLabel.text = _viewModel.passwordText
        logInView.passwordTextField.placeholder = _viewModel.passwordPlaceholderText
        if let passwordValidationMessageLabel = logInView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        if let passwordVisibilityButton = logInView.passwordVisibilityButton {
            passwordVisibilityButton.rex_pressed.value = _viewModel.togglePasswordVisibility.unsafeCocoaAction
            _viewModel.showPassword.signal.observeNext { [unowned self] showPassword in
                passwordVisibilityButton.setTitle(self._viewModel.passwordVisibilityButtonTitle, forState: .Normal)
                self.logInView.passwordTextField.secureTextEntry = !showPassword
            }
        }
    }
    
    func bindButtons() {
        logInView.loginButton.setTitle(_viewModel.loginButtonTitle, forState: .Normal)
        logInView.loginButton.rex_pressed.value = _viewModel.logInCocoaAction
        
        logInView.registerButton.setTitle(_viewModel.registerButtonTitle, forState: .Normal)
        logInView.registerButton.setAction { [unowned self] _ in self._onRegister(self) }
        
        // loginView.termsAndService -> Present modally web view controller that shows HTML file
        logInView.termsAndService?.setTitle(_viewModel.termsAndServicesButtonTitle, forState: .Normal)
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
