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


public final class LogInController : UIViewController {
    
    private let _viewModel: LogInViewModelType
    private let _onLogInError: (SessionServiceError) -> ()
    private let _onRegister: (UIButton) -> ()
    
    public let logInView: LogInViewType
    
    init(viewModel: LogInViewModelType,
        logInView: LogInViewType = LogInView(),
        onLogInError: (SessionServiceError) -> (),
        onRegister: (UIButton) -> ()
    ) {
            _viewModel = viewModel
            _onLogInError = onLogInError
            _onRegister = onRegister
            self.logInView = logInView
            super.init(nibName: nil, bundle: nil) //TODO
    }

    required public init?(coder aDecoder: NSCoder) { //TODO
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        view.addSubview(logInView as! UIView)
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
        
        _viewModel.logInErrors.observeNext(_onLogInError)
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
        logInView.registerButton.setAction { [unowned self] in self._onRegister($0) }
        
        // loginView.termsAndService -> Present modally web view controller that shows HTML file
        logInView.termsAndService?.setTitle(_viewModel.termsAndServicesButtonTitle, forState: .Normal)
    }
    
}