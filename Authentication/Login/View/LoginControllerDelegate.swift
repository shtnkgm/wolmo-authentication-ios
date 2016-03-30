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
    
    func shouldDisplayLoginErrorWithAlert() -> Bool

    func loginControllerWillExecuteLogIn(controller: LoginController)
    
    func loginControllerDidExecuteLogIn(controller: LoginController)
    
    func loginController(controller: LoginController, didLogInWithError error: SessionServiceError)
    
    func loginControllerDidPassEmailValidation(controller: LoginController)
    
    func loginController(controller: LoginController, didFailEmailValidationWithErrors errors: [String])
    
    func loginControllerDidPassPasswordValidation(controller: LoginController)
    
    func loginController(controller: LoginController, didFailPasswordValidationWithErrors errors: [String])
    
}

extension LoginControllerDelegate {
    
    public func loginControllerWillExecuteLogIn(controller: LoginController) {
        controller.loginView.emailTextFieldValid = true
        controller.loginView.passwordTextFieldValid = true
        if let errorLabel = controller.loginView.logInErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    public func loginControllerDidExecuteLogIn(controller: LoginController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    public func shouldDisplayLoginErrorWithAlert() -> Bool {
        return true
    }
    
    public func loginController(controller: LoginController, didLogInWithError error: SessionServiceError) {
        controller.loginView.emailTextFieldValid = false
        controller.loginView.passwordTextFieldValid = false
        
        if let logInErrorLabel = controller.loginView.logInErrorLabel && !shouldDisplayLoginErrorWithAlert() {
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

public final class DefaultLoginControllerDelegate: LoginControllerDelegate { }
