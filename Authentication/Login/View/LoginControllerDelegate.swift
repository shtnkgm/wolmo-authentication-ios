//
//  LoginControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/15/16.
//  Copyright © 2016 Wolox. All rights reserved.
//


/*
    Protocol for login controller delegates.
    Create your own delegate and override any of
    the defaut methods to add behaviour to your
    login process.
*/
public protocol LoginControllerDelegate {
    
    /* Property indicating if the login errors
    should be shown with an alert, apart from 
    the login errors label if it exists. */
    var shouldDisplayLoginErrorWithAlert: Bool { get }

    /* Function called when the login action begins executing,
       before setting the `logInButtonPressed` property of the view used. */
    func willExecuteLogIn(controller: LoginController)
    
    /* Function called when the login action ended with success,
     before setting the `logInButtonPressed` property of the view used. */
    func didExecuteLogIn(controller: LoginController)
    
    /* Function called when the login action ended with error,
     before setting the `logInButtonPressed` property of the view used. */
    func didLogIn(controller: LoginController, with error: SessionServiceError)
    
    /* Function called when any new email introduced is valid,
       before setting the `emailTextFieldValid` property of the view used. */
    func didPassEmailValidation(controller: LoginController)
    
    /* Function called when any new email introduced is invalid,
     before setting the `emailTextFieldValid` property of the view used. */
    func didFailEmailValidation(controller: LoginController, with errors: [String])
    
    /* Function called when any new password introduced is valid,
     before setting the `passwordTextFieldValid` property of the view used. */
    func didPassPasswordValidation(controller: LoginController)
    
    /* Function called when any new password introduced is valid,
     before setting the `passwordTextFieldValid` property of the view used. */
    func didFailPasswordValidation(controller: LoginController, with errors: [String])
    
}

extension LoginControllerDelegate {
    
    /* By default, true. */
    public var shouldDisplayLoginErrorWithAlert: Bool { return true }
    
    /* By default, it clears old errors from label and
       activates the Network Activity Indicator in the status bar. */
    public func willExecuteLogIn(controller: LoginController) {
        if let errorLabel = controller.loginView.logInErrorLabel {
            errorLabel.text = " "
        }
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }
    
    /* By default, it deactivates the Network Activity Indicator in the status bar. */
    public func didExecuteLogIn(controller: LoginController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }
    
    /* By default, it deactivates the Network Activity Indicator in the status bar,
       fills the error label with the error message and if the property
       `shouldDisplayLoginErrorWithAlert` is set to true, shows an alert with the error. */
    public func didLogIn(controller: LoginController, with error: SessionServiceError) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
        if let errorLabel = controller.loginView.logInErrorLabel {
            errorLabel.text = error.message
        }
        if shouldDisplayLoginErrorWithAlert {
            let alert = UIAlertController(title: "login-error.alert.title".frameworkLocalized, message: error.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "login-error.alert.close".frameworkLocalized, style: .Default, handler: nil))
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /* By default, it does nothing. */
    public func didPassEmailValidation(controller: LoginController) { }
    
    /* By default, it does nothing. */
    public func didFailEmailValidation(controller: LoginController, with errors: [String]) { }
    
    /* By default, it does nothing. */
    public func didPassPasswordValidation(controller: LoginController) { }
    
    /* By default, it does nothing. */
    public func didFailPasswordValidation(controller: LoginController, with errors: [String]) { }
    
}

public final class DefaultLoginControllerDelegate: LoginControllerDelegate { }
