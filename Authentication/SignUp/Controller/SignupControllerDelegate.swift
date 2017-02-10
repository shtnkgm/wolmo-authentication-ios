//
//  SignupControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Protocol for signup controller delegates,
     that add behaviour to certain events from
     the signup process.
 */
public protocol SignupControllerDelegate {
    
    /**
        Property indicating if the signup errors
        should be shown with an alert, apart from
        the signup errors label if it exists.
         
        By default, true.
     */
    var shouldDisplaySignupErrorWithAlert: Bool { get }
    
    /**
        Function called when the signup action begins executing,
        before setting the `signUpButtonPressed` property of the view used.
        
        By default, it clears old errors from label and
        activates the Network Activity Indicator in the status bar.
     
        - Parameter controller: SignupController where the event is happening.
     */
    func willExecuteSignUp(in controller: SignupController)
    
    /**
        Function called when the signup action ended with success,
        before setting the `signUpButtonPressed` property of the view used.
     
        By default, it deactivates the Network Activity Indicator in the status bar.
     
        - Parameter controller: SignupController where the event is happening.
     */
    func didExecuteSignUp(in controller: SignupController)
    
    /**
         Function called when the signup action ended with error,
         before setting the `signUpButtonPressed` property of the view used.
         
         By default, it deactivates the Network Activity Indicator in the status bar,
         fills the error label with the error message and if the property
         `shouldDisplaySignupErrorWithAlert` is set to true, shows an alert with the error.
     
         - Parameter controller: SignupController where the event is happening.
         - Parameter with: error resulting from the sign up attempt.
     */
    func didFailSignUp(in controller: SignupController, with error: SessionServiceError)
    
    /**
         Function called when any new username introduced is valid,
         before setting the `usernameTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
     */
    func didPassUsernameValidation(in controller: SignupController)
    
    /** 
         Function called when any new username introduced is invalid,
         before setting the `usernameTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
         - Parameter with: username validation errors.
     */
    func didFailUsernameValidation(in controller: SignupController, with errors: [String])
    
    /** 
         Function called when any new email introduced is valid,
         before setting the `emailTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
     */
    func didPassEmailValidation(in controller: SignupController)
    
    /** 
         Function called when any new email introduced is invalid,
         before setting the `emailTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
         - Parameter with: email validation errors.
     */
    func didFailEmailValidation(in controller: SignupController, with errors: [String])
    
    /** 
         Function called when any new password introduced is valid,
         before setting the `passwordTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
     */
    func didPassPasswordValidation(in controller: SignupController)
    
    /** 
         Function called when any new password introduced is invalid,
         before setting the `passwordTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
         - Parameter with: password validation errors.
     */
    func didFailPasswordValidation(in controller: SignupController, with errors: [String])

    /** 
         Function called when any new password confirmation introduced is valid,
         before setting the `passwordConfirmationTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
     */
    func didPassPasswordConfirmationValidation(in controller: SignupController)
    
    /** 
         Function called when any new password confirmation introduced is invalid,
         before setting the `passwordConfirmationTextFieldValid` property of the view used.
         
         By default, it does nothing.
     
         - Parameter controller: SignupController where the event is happening.
         - Parameter with: password confirmation validation errors.
     */
    func didFailPasswordConfirmationValidation(in controller: SignupController, with errors: [String])
    
}

extension SignupControllerDelegate {
    
    public var shouldDisplaySignupErrorWithAlert: Bool { return true }
    
    public func willExecuteSignUp(in controller: SignupController) {
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = true
    }
    
    public func didExecuteSignUp(in controller: SignupController) {
        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = false
    }
    
    public func didFailSignUp(in controller: SignupController, with error: SessionServiceError) {
        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = false
        if let errorLabel = controller.signupView.signUpErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplaySignupErrorWithAlert {
            let alert = UIAlertController(title: "signup-error.alert.title".frameworkLocalized, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "signup-error.alert.close".frameworkLocalized, style: .default, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    public func didPassUsernameValidation(in controller: SignupController) { }
    
    public func didFailUsernameValidation(in controller: SignupController, with errors: [String]) { }
    
    public func didPassEmailValidation(in controller: SignupController) { }
    
    public func didFailEmailValidation(in controller: SignupController, with errors: [String]) { }
    
    public func didPassPasswordValidation(in controller: SignupController) { }
    
    public func didFailPasswordValidation(in controller: SignupController, with errors: [String]) { }
    
    public func didPassPasswordConfirmationValidation(in controller: SignupController) { }
    
    public func didFailPasswordConfirmationValidation(in controller: SignupController, with errors: [String]) { }
    
}

/**
     The default signup controller delegate operates with the
     default behaviour of the SignupControllerDelegate protocol's methods.
 */
public final class DefaultSignupControllerDelegate: SignupControllerDelegate { }
