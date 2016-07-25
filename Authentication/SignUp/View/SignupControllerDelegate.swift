//
//  SignupControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupControllerDelegate {
    
    var shouldDisplaySignupErrorWithAlert: Bool { get }
    
    func willExecuteSignUp(controller: SignupController)
    
    func didExecuteSignUp(controller: SignupController)
    
    func didSignUp(controller: SignupController, with error: SessionServiceError)
    
    func didPassNameValidation(controller: SignupController)
    
    func didFailNameValidation(controller: SignupController, with errors: [String])
    
    func didPassEmailValidation(controller: SignupController)
    
    func didFailEmailValidation(controller: SignupController, with errors: [String])
    
    func didPassPasswordValidation(controller: SignupController)
    
    func didFailPasswordValidation(controller: SignupController, with errors: [String])

    func didPassPasswordConfirmationValidation(controller: SignupController)
    
    func didFailPasswordConfirmationValidation(controller: SignupController, with errors: [String])
    
}

extension SignupControllerDelegate {
    
    public var shouldDisplaySignupErrorWithAlert: Bool { return true }
    
    public func willExecuteSignUp(controller: SignupController) {
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    public func didExecuteSignUp(controller: SignupController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    public func didSignUp(controller: SignupController, with error: SessionServiceError) {
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplaySignupErrorWithAlert {
            let alert = UIAlertController(title: "signup-error.alert.title".frameworkLocalized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close".frameworkLocalized, style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func didPassNameValidation(controller: SignupController) {
        controller.signupView.usernameTextFieldValid = true
    }
    
    public func didFailNameValidation(controller: SignupController, with errors: [String]) {
        controller.signupView.usernameTextFieldValid = false
    }
    
    public func didPassEmailValidation(controller: SignupController) {
        controller.signupView.emailTextFieldValid = true
    }
    
    public func didFailEmailValidation(controller: SignupController, with errors: [String]) {
        controller.signupView.emailTextFieldValid = false
    }
    
    public func didPassPasswordValidation(controller: SignupController) {
        controller.signupView.passwordTextFieldValid = true
    }
    
    public func didFailPasswordValidation(controller: SignupController, with errors: [String]) {
        controller.signupView.passwordTextFieldValid = false
    }
    
    public func didPassPasswordConfirmationValidation(controller: SignupController) {
        controller.signupView.passwordConfirmationTextFieldValid = true
    }
    
    public func didFailPasswordConfirmationValidation(controller: SignupController, with errors: [String]) {
        controller.signupView.passwordConfirmationTextFieldValid = false
    }
    
}

public final class DefaultSignupControllerDelegate: SignupControllerDelegate { }
