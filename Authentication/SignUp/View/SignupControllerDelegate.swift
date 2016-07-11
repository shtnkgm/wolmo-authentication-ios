//
//  SignupControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupControllerDelegate {
    
    var shouldDisplaySignupErrorWithAlert: Bool
    
    func signupControllerWillExecuteSignUp(controller: SignupController)
    
    func signupControllerDidExecuteSignUp(controller: SignupController)
    
    func signupController(controller: SignupController, didSignUpWithError error: SessionServiceError)
    
    func signupControllerDidPassNameValidation(controller: SignupController)
    
    func signupController(controller: SignupController, didFailNameValidationWithErrors errors: [String])
    
    func signupControllerDidPassEmailValidation(controller: SignupController)
    
    func signupController(controller: SignupController, didFailEmailValidationWithErrors errors: [String])
    
    func signupControllerDidPassPasswordValidation(controller: SignupController)
    
    func signupController(controller: SignupController, didFailPasswordValidationWithErrors errors: [String])

    func signupControllerDidPassPasswordConfirmationValidation(controller: SignupController)
    
    func signupController(controller: SignupController, didFailPasswordConfirmationValidationWithErrors errors: [String])
    
}

extension SignupControllerDelegate {
    
    public var shouldDisplaySignupErrorWithAlert: Bool { return true }
    
    public func signupControllerWillExecuteSignUp(controller: SignupController) {
        if let errorLabel = controller.signupView.signupErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    public func signupControllerDidExecuteSignUp(controller: SignupController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    public func signupController(controller: SignupController, didSignUpWithError error: SessionServiceError) {
        controller.signupView.usernameTextFieldValid = false
        controller.signupView.emailTextFieldValid = false
        controller.signupView.passwordTextFieldValid = false
        controller.signupView.passwordConfirmationTextFieldValid = false
        controller.signupView.signupButtonPressed = false
        
        if let errorLabel = controller.signupView.signupErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplaySignupErrorWithAlert {
            let alert = UIAlertController(title: "signup-error.alert.title".localized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close", style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func signupControllerDidPassNameValidation(controller: SignupController) {
        controller.signupView.usernameTextFieldValid = true
    }
    
    public func signupController(controller: SignupController, didFailNameValidationWithErrors errors: [String]) {
        controller.signupView.usernameTextFieldValid = false
    }
    
    public func signupControllerDidPassEmailValidation(controller: SignupController) {
        controller.signupView.emailTextFieldValid = true
    }
    
    public func signupController(controller: SignupController, didFailEmailValidationWithErrors errors: [String]) {
        controller.signupView.emailTextFieldValid = false
    }
    
    public func signupControllerDidPassPasswordValidation(controller: SignupController) {
        controller.signupView.passwordTextFieldValid = true
    }
    
    public func signupController(controller: SignupController, didFailPasswordValidationWithErrors errors: [String]) {
        controller.signupView.passwordTextFieldValid = false
    }
    
    public func signupControllerDidPassPasswordConfirmationValidation(controller: SignupController) {
        controller.signupView.passwordConfirmationTextFieldValid = true
    }
    
    public func signupController(controller: SignupController, didFailPasswordConfirmationValidationWithErrors errors: [String]) {
        controller.signupView.passwordConfirmationTextFieldValid = false
    }
    
}

public final class DefaultSignupControllerDelegate: SignupControllerDelegate { }
