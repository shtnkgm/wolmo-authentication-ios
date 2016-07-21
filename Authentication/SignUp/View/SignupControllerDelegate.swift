//
//  SignupControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//


/*
     Protocol for signup controller delegates.
     Create your own delegate and override any of
     the defaut methods to add behaviour to your
     singup process.
 */
public protocol SignupControllerDelegate {
    
    /* Property indicating if the signup errors
     should be shown with an alert, apart from
     the signup errors label if it exists. */
    var shouldDisplaySignupErrorWithAlert: Bool { get }
    
    /* Function called when the signup action begins executing,
       before setting the `signUpButtonPressed` property of the view used. */
    func willExecuteSignUp(controller: SignupController)
    
    /* Function called when the signup action ended with success,
       before setting the `signUpButtonPressed` property of the view used. */
    func didExecuteSignUp(controller: SignupController)
    
    /* Function called when the signup action ended with error,
       before setting the `signUpButtonPressed` property of the view used. */
    func didSignUp(controller: SignupController, with error: SessionServiceError)
    
    /* Function called when any new username introduced is valid,
       before setting the `usernameTextFieldValid` property of the view used. */
    func didPassNameValidation(controller: SignupController)
    
    /* Function called when any new username introduced is invalid,
       before setting the `usernameTextFieldValid` property of the view used. */
    func didFailNameValidation(controller: SignupController, with errors: [String])
    
    /* Function called when any new email introduced is valid,
       before setting the `emailTextFieldValid` property of the view used. */
    func didPassEmailValidation(controller: SignupController)
    
    /* Function called when any new email introduced is invalid,
       before setting the `emailTextFieldValid` property of the view used. */
    func didFailEmailValidation(controller: SignupController, with errors: [String])
    
    /* Function called when any new password introduced is valid,
       before setting the `passwordTextFieldValid` property of the view used. */
    func didPassPasswordValidation(controller: SignupController)
    
    /* Function called when any new password introduced is invalid,
       before setting the `passwordTextFieldValid` property of the view used. */
    func didFailPasswordValidation(controller: SignupController, with errors: [String])

    /* Function called when any new password confirmation introduced is valid,
       before setting the `passwordConfirmationTextFieldValid` property of the view used. */
    func didPassPasswordConfirmationValidation(controller: SignupController)
    
    /* Function called when any new password confirmation introduced is invalid,
       before setting the `passwordConfirmationTextFieldValid` property of the view used. */
    func didFailPasswordConfirmationValidation(controller: SignupController, with errors: [String])
    
}

extension SignupControllerDelegate {
    
    /* By default, true. */
    public var shouldDisplaySignupErrorWithAlert: Bool { return true }
    
    /* By default, it clears old errors from label and
       activates the Network Activity Indicator in the status bar. */
    public func willExecuteSignUp(controller: SignupController) {
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    /* By default, it deactivates the Network Activity Indicator in the status bar. */
    public func didExecuteSignUp(controller: SignupController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    /* By default, it deactivates the Network Activity Indicator in the status bar,
     fills the error label with the error message and if the property
     `shouldDisplaySignupErrorWithAlert` is set to true, shows an alert with the error. */
    public func didSignUp(controller: SignupController, with error: SessionServiceError) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplaySignupErrorWithAlert {
            let alert = UIAlertController(title: "signup-error.alert.title".frameworkLocalized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close".frameworkLocalized, style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /* By default, it does nothing. */
    public func didPassNameValidation(controller: SignupController) { }
    
    /* By default, it does nothing. */
    public func didFailNameValidation(controller: SignupController, with errors: [String]) { }
    
    /* By default, it does nothing. */
    public func didPassEmailValidation(controller: SignupController) { }
    
    /* By default, it does nothing. */
    public func didFailEmailValidation(controller: SignupController, with errors: [String]) { }
    
    /* By default, it does nothing. */
    public func didPassPasswordValidation(controller: SignupController) { }
    
    /* By default, it does nothing. */
    public func didFailPasswordValidation(controller: SignupController, with errors: [String]) { }
    
    /* By default, it does nothing. */
    public func didPassPasswordConfirmationValidation(controller: SignupController) { }
    
    /* By default, it does nothing. */
    public func didFailPasswordConfirmationValidation(controller: SignupController, with errors: [String]) { }
    
}

public final class DefaultSignupControllerDelegate: SignupControllerDelegate { }
