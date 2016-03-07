//
//  File.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa


final public class LogInController: UIViewController {
    
    private let _viewModel: LogInViewModel<UserType, SessionServiceType>
    private let _onUserLoggedIn: UserType -> ()
    private let _registerControllerFactory: () -> RegisterControllerType
    
    public let logInView: LogInViewType
    
    init(viewModel: LogInViewModel<UserType, SessionServiceType>,
        registerControllerFactory: () -> RegisterControllerType,
        loginView: LogInViewType = LogInView(),
        onUserLoggedIn: UserType -> () = { _ in }) {
            
            _viewModel = viewModel
            _registerControllerFactory = registerControllerFactory
            _onUserLoggedIn = onUserLoggedIn
            self.loginView = loginView
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
        _viewModel.email <~ logInView.emailTextField.rex_textSignal
        logInView.emailLabel.text = _viewModel.emailText
        logInView.emailTextField.placeholder = _viewModel.emailPlaceholderText
        if let emailValidationMessageLabel = logInView.emailValidationMessageLabel {
            _viewModel.emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? " " }
        }
        
        _viewModel.password <~ logInView.passwordTextField.rex_textSignal
        logInView.passwordLabel.text = _viewModel.passwordText
        logInView.passwordTextField.placeholder = _viewModel.passwordPlaceholderText
        if let passwordValidationMessageLabel = logInView.passwordValidationMessageLabel {
            _viewModel.passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        if let passwordVisibilityButton = logInView.passwordVisibilityButton {
            passwordVisibilityButton.mode <~ _viewModel.showPassword.signal.map { PasswordVisibilityButton.Mode($0) }
        }
        
        logInView.loginButton.setTitle(_viewModel.loginButtonTitle, state: .Normal)
        logInView.loginButton.rex_pressed.value = _viewModel.login.unsafeCocoaAction
        
        logInView.registerButton.setTitle(_viewModel.registerButtonTitle, state: .Normal)
        logInView.registerButton.action { [unowned self] _ in
            let controller = self._registerControllerFactory()
            navigationController?.pushViewController(controller, animated: true)
        }
        
        // loginView.termsAndService -> Present modally web view controller that shows HTML file
        logInView.termsAndService?.setTitle(_viewModel.termsAndServiceButtonTitle, state: .Normal)
        
        _viewModel.login.executing.producer { executing in
            if executing {
                // Show spinner
            } else {
                // Hide spinner
            }
        }
        
        _viewModel.login.errors.observeNext { [unowned self] error in
            let controller = loginErrorControllerFactory(error)
            self.presentViewController(controller, animated: false, completion: nil)
        }
        
        _viewModel.login.values.observeNext(_onUserLoggedIn)
    }
    
}