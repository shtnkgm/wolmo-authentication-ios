//
//  RegisterControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol RegisterControllerDelegate {
    
    func signupControllerWillExecuteSignUp(controller: RegisterController)
    
    func signupControllerDidExecuteSignUp(controller: RegisterController)
    
    func signupController(controller: RegisterController, didSignUpWithError error: SessionServiceError)
    
    func signupControllerDidPassNameValidation(controller: RegisterController)
    
    func signupController(controller: RegisterController, didFailNameValidationWithErrors errors: [String])
    
    func signupControllerDidPassEmailValidation(controller: RegisterController)
    
    func signupController(controller: RegisterController, didFailEmailValidationWithErrors errors: [String])
    
    func signupControllerDidPassPasswordValidation(controller: RegisterController)
    
    func signupController(controller: RegisterController, didFailPasswordValidationWithErrors errors: [String])

    func signupControllerDidPassPasswordConfirmationValidation(controller: RegisterController)
    
    func signupController(controller: RegisterController, didFailPasswordConfirmationValidationWithErrors errors: [String])
    
}

extension RegisterControllerDelegate {
    
    public func signupControllerWillExecuteSignUp(controller: RegisterController) {
        if let errorLabel = controller.signupView.registerErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    public func signupControllerDidExecuteSignUp(controller: RegisterController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    public func signupController(controller: RegisterController, didSignUpWithError error: SessionServiceError) {
        controller.signupView.usernameTextFieldValid = false
        controller.signupView.emailTextFieldValid = false
        controller.signupView.passwordTextFieldValid = false
        controller.signupView.passwordConfirmationTextFieldValid = false
        
        if let errorLabel = controller.signupView.registerErrorLabel {
            errorLabel.text = error.message
        } else {
            let alert = UIAlertController(title: "signup-error.alert.title".localized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close", style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func signupControllerDidPassNameValidation(controller: RegisterController) {
        controller.signupView.usernameTextFieldValid = true
    }
    
    public func signupController(controller: RegisterController, didFailNameValidationWithErrors errors: [String]) {
        controller.signupView.usernameTextFieldValid = false
    }
    
    public func signupControllerDidPassEmailValidation(controller: RegisterController) {
        controller.signupView.emailTextFieldValid = true
    }
    
    public func signupController(controller: RegisterController, didFailEmailValidationWithErrors errors: [String]) {
        controller.signupView.emailTextFieldValid = false
    }
    
    public func signupControllerDidPassPasswordValidation(controller: RegisterController) {
        controller.signupView.passwordTextFieldValid = true
    }
    
    public func signupController(controller: RegisterController, didFailPasswordValidationWithErrors errors: [String]) {
        controller.signupView.passwordTextFieldValid = false
    }
    
    public func signupControllerDidPassPasswordConfirmationValidation(controller: RegisterController) {
        controller.signupView.passwordConfirmationTextFieldValid = true
    }
    
    public func signupController(controller: RegisterController, didFailPasswordConfirmationValidationWithErrors errors: [String]) {
        controller.signupView.passwordConfirmationTextFieldValid = false
    }
    
}

public final class DefaultRegisterControllerDelegate: RegisterControllerDelegate { }
