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
    
    func didSignUpWithError(controller: SignupController, error: SessionServiceError)
    
    func didPassNameValidation(controller: SignupController)
    
    func didFailNameValidationWithErrors(controller: SignupController, errors: [String])
    
    func didPassEmailValidation(controller: SignupController)
    
    func didFailEmailValidationWithErrors(controller: SignupController, errors: [String])
    
    func didPassPasswordValidation(controller: SignupController)
    
    func didFailPasswordValidationWithErrors(controller: SignupController, errors: [String])

    func didPassPasswordConfirmationValidation(controller: SignupController)
    
    func didFailPasswordConfirmationValidationWithErrors(controller: SignupController, errors: [String])
    
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
    
    public func didSignUpWithError(controller: SignupController, error: SessionServiceError) {
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplaySignupErrorWithAlert {
            let alert = UIAlertController(title: "signup-error.alert.title".localized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close".localized, style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func didPassNameValidation(controller: SignupController) {
        controller.signupView.usernameTextFieldValid = true
    }
    
    public func didFailNameValidationWithErrors(controller: SignupController, errors: [String]) {
        controller.signupView.usernameTextFieldValid = false
    }
    
    public func didPassEmailValidation(controller: SignupController) {
        controller.signupView.emailTextFieldValid = true
    }
    
    public func didFailEmailValidationWithErrors(controller: SignupController, errors: [String]) {
        controller.signupView.emailTextFieldValid = false
    }
    
    public func didPassPasswordValidation(controller: SignupController) {
        controller.signupView.passwordTextFieldValid = true
    }
    
    public func didFailPasswordValidationWithErrors(controller: SignupController, errors: [String]) {
        controller.signupView.passwordTextFieldValid = false
    }
    
    public func didPassPasswordConfirmationValidation(controller: SignupController) {
        controller.signupView.passwordConfirmationTextFieldValid = true
    }
    
    public func didFailPasswordConfirmationValidationWithErrors(controller: SignupController, errors: [String]) {
        controller.signupView.passwordConfirmationTextFieldValid = false
    }
    
}

public final class DefaultSignupControllerDelegate: SignupControllerDelegate { }
