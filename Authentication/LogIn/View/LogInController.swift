//
//  File.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Rex


final public class LogInController<User: UserType, SessionService: SessionServiceType where SessionService.User == User>: UIViewController {
    
    private let _viewModel: LogInViewModel<User, SessionService>
    private let _onUserLoggedIn: User -> ()
    private let _registerControllerFactory: () -> RegisterController
    private let _logInErrorControllerFactory: (NSError) -> LogInErrorController
    
    public let logInView: LogInViewType
    
    init<User: UserType, SessionService: SessionServiceType where SessionService.User == User>(viewModel: LogInViewModel<User, SessionService>,
        logInView: LogInViewType = LogInView(),
        onUserLoggedIn: User -> () = { _ in },
        onRegister: () -> (),
        logInErrorControllerFactory: (NSError) -> LogInErrorController) {
            
            _viewModel = viewModel
            _registerControllerFactory = registerControllerFactory
            _onUserLoggedIn = onUserLoggedIn
            _logInErrorControllerFactory = logInErrorControllerFactory
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
        
        _viewModel.login.executing.signal.observeNext { [unowned self] executing in
            if executing {
                self.logInView.activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            } else {
                self.logInView.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
        
        _viewModel.login.errors.observeNext { [unowned self] error in
            let controller = self._logInErrorControllerFactory(error)
            self.presentViewController(controller, animated: false, completion: nil)
        }
        
        _viewModel.login.values.observeNext(_onUserLoggedIn)
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
        logInView.loginButton.rex_pressed.value = _viewModel.login.unsafeCocoaAction
        
        logInView.registerButton.setTitle(_viewModel.registerButtonTitle, forState: .Normal)
        //        logInView.registerButton.action { [unowned self] _ in
        //            let controller = self._registerControllerFactory()
        //            navigationController?.pushViewController(controller, animated: true)
        //        }
        logInView.registerButton.addTarget(self, action: "transitionToSignUp:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // loginView.termsAndService -> Present modally web view controller that shows HTML file
        logInView.termsAndService?.setTitle(_viewModel.termsAndServicesButtonTitle, forState: .Normal)
    }
    
    func transitionToSignUp(sender: UIButton) {
        let controller = self._registerControllerFactory()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}