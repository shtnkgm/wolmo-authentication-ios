//
//  LoginControllerDelegateType.swift
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
public protocol LoginControllerDelegateType {
    
    func loginControllerWillExecuteLogIn(controller: LoginController)
    
    func loginControllerDidExecuteLogIn(controller: LoginController)
    
    func loginController(controller: LoginController, didLogInWithError error: SessionServiceError)
    
}

extension LoginControllerDelegateType {
    
    public func loginControllerWillExecuteLogIn(controller: LoginController) {
        controller.loginView.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    public func loginControllerDidExecuteLogIn(controller: LoginController) {
        controller.loginView.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    public func loginController(controller: LoginController, didLogInWithError error: SessionServiceError) {
        if let logInErrorLabel = controller.loginView.logInErrorLabel {
            logInErrorLabel.text = error.message
        } else {
            let alert = UIAlertController(title: "", message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "", style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}

public final class DefaultLoginControllerDelegate: LoginControllerDelegateType { }