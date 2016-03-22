//
//  LoginControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/15/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


/**
    Protocol gor login controller delegates.
    Create your own delegate and override any of the defaut methods to
    add behaviour to your login process.
*/
public protocol LoginControllerDelegate {
    
    /**
        The protocol offers a default implementation for these functions.
     */
    func loginControllerWillExecuteLogIn(controller: LoginController)
    func loginControllerDidExecuteLogIn(controller: LoginController)
    func loginController(controller: LoginController, didLogInWithError error: SessionServiceError)
    
    func loginControllerDidPassEmailValidation(controller: LoginController)
    func loginController(controller: LoginController, didFailEmailValidationWithErrors errors: [String])
    func loginControllerDidPassPasswordValidation(controller: LoginController)
    func loginController(controller: LoginController, didFailPasswordValidationWithErrors errors: [String])
    
    /**
        These functions are of mandatory implementation.
    */
    func onRegister(controller: LoginController)
    func onRecoverPassword(controller: LoginController)
    
}

extension LoginControllerDelegate {
    
    public func loginControllerWillExecuteLogIn(controller: LoginController) {
        // Start activity indicator
    }
    
    public func loginControllerDidExecuteLogIn(controller: LoginController) {
        // Finish activity indicator
    }
    
    public func loginController(controller: LoginController, didLogInWithError error: SessionServiceError) {
        controller.loginView.emailTextFieldValid = false
        controller.loginView.passwordTextFieldValid = false
        
        if let logInErrorLabel = controller.loginView.logInErrorLabel {
            logInErrorLabel.text = error.message
        } else {
            let alert = UIAlertController(title: "login-error.alert.title".localized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "login-error.alert.close", style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func loginControllerDidPassEmailValidation(controller: LoginController) {
        controller.loginView.emailTextFieldValid = true
    }
    
    public func loginController(controller: LoginController, didFailEmailValidationWithErrors errors: [String]) {
        controller.loginView.emailTextFieldValid = false
    }
    
    public func loginControllerDidPassPasswordValidation(controller: LoginController) {
        controller.loginView.passwordTextFieldValid = true
    }
    
    public func loginController(controller: LoginController, didFailPasswordValidationWithErrors errors: [String]) {
        controller.loginView.passwordTextFieldValid = false
    }
    
}

public final class DefaultLoginControllerDelegate: LoginControllerDelegate {
    
    private let _window: UIWindow
    private let _registerControllerFactory: () -> RegisterController
    private let _recoverPasswordControllerFactory: () -> RecoverPasswordController
    
    init(window: UIWindow,
        registerControllerFactory: () -> RegisterController = { return RegisterController(viewModel: RegisterViewModel(), registerViewFactory: { return RegisterView() }) },
        recoverPasswordControllerFactory: () -> RecoverPasswordController = { return RecoverPasswordController() }) {
            _window = window
            _registerControllerFactory = registerControllerFactory
            _recoverPasswordControllerFactory = recoverPasswordControllerFactory
    }
    
    public func onRegister(controller: LoginController) {
        let registerController = _registerControllerFactory()
        if let navigationController = self._window.rootViewController?.navigationController {
            navigationController.pushViewController(registerController, animated: true)
        } else {
            self._window.rootViewController = UINavigationController(rootViewController: registerController)
        }
        
    }
    
    public func onRecoverPassword(controller: LoginController) {
        let recoverPasswordController = _recoverPasswordControllerFactory()
        if let navigationController = controller.navigationController {
            navigationController.pushViewController(recoverPasswordController, animated: true)
        } else {
            self._window.rootViewController = UINavigationController(rootViewController: recoverPasswordController)
        }
    }
    
}
