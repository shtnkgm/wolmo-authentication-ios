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
    
    var shouldDisplayLoginErrorWithAlert: Bool { get }

    func willExecuteLogIn(controller: LoginController)
    
    func didExecuteLogIn(controller: LoginController)
    
    func didLogIn(controller: LoginController, with error: SessionServiceError)
    
    func didPassEmailValidation(controller: LoginController)
    
    func didFailEmailValidation(controller: LoginController, with errors: [String])
    
    func didPassPasswordValidation(controller: LoginController)
    
    func didFailPasswordValidation(controller: LoginController, with errors: [String])
    
}

extension LoginControllerDelegate {
    
    public var shouldDisplayLoginErrorWithAlert: Bool { return true }
    
    public func willExecuteLogIn(controller: LoginController) {
        controller.loginView.emailTextFieldValid = true
        controller.loginView.passwordTextFieldValid = true
        if let errorLabel = controller.loginView.logInErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    public func didExecuteLogIn(controller: LoginController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    public func didLogIn(controller: LoginController, with error: SessionServiceError) {
        if let errorLabel = controller.loginView.logInErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplayLoginErrorWithAlert {
            let alert = UIAlertController(title: "login-error.alert.title".localized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "login-error.alert.close".localized, style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func didPassEmailValidation(controller: LoginController) {
        controller.loginView.emailTextFieldValid = true
    }
    
    public func didFailEmailValidation(controller: LoginController, with errors: [String]) {
        controller.loginView.emailTextFieldValid = false
    }
    
    public func didPassPasswordValidation(controller: LoginController) {
        controller.loginView.passwordTextFieldValid = true
    }
    
    public func didFailPasswordValidation(controller: LoginController, with errors: [String]) {
        controller.loginView.passwordTextFieldValid = false
    }
    
}

public final class DefaultLoginControllerDelegate: LoginControllerDelegate { }
