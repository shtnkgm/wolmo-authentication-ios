//
//  LoginViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/*
    Delegate for any extra configuration
    to the login view when rendered.
*/
public protocol LoginViewDelegate {
    
    /* Palettes ued to configure all login view elements possible. */
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    /* Function to configure all view elements according to the palettes.
       It is called by the default login view when rendered. */
    func configureView(loginView: LoginViewType)
    
}

public extension LoginViewDelegate {
    
    /* By default, does nothing. */
    func configureView(loginView: LoginViewType) { }
    
}

/*
    The default login view delegate takes care of:
       setting the logo image according to the configuration and
       setting all LoginViewType elements possible according to palettes.
 
    If wanting to use the DefaultLoginViewDelegate with some palette or logo customization,
    you should not override the `createLoginViewDelegate` method of the Bootstrapper,
    but pass the correct LoginViewConfigurationType to the bootstraper in the
    `AuthenticationViewConfiguration`.
*/
public final class DefaultLoginViewDelegate: LoginViewDelegate {
    
    private let _configuration: LoginViewConfigurationType

    public var colorPalette: ColorPaletteType { return _configuration.colorPalette }
    public var fontPalette: FontPaletteType { return _configuration.fontPalette }
    
    internal init(configuration: LoginViewConfigurationType = LoginViewConfiguration()) {
        _configuration = configuration
    }
    
    public func configureView(loginView: LoginViewType) {
        if let logo = _configuration.logoImage {
            loginView.logoImageView.image = logo
        }
        
        loginView.view.backgroundColor = colorPalette.background
        
        configureMainButton(loginView)
        configureEmailElements(loginView)
        configurePasswordElements(loginView)
        configureLinksElements(loginView)
        configureErrorElements(loginView)
    }
    
    private func configureMainButton(loginView: LoginViewType) {
        loginView.logInButton.backgroundColor = colorPalette.mainButtonDisabled
        loginView.logInButton.titleLabel?.font = fontPalette.mainButton
        loginView.logInButton.titleLabel?.textColor = colorPalette.mainButtonText
    }
    
    private func configureEmailElements(loginView: LoginViewType) {
        loginView.emailLabel?.font = fontPalette.labels
        loginView.emailLabel?.textColor = colorPalette.labels
        loginView.emailTextField.font = fontPalette.textfields
        loginView.emailTextField.textColor = colorPalette.textfieldText
    }
    
    private func configurePasswordElements(loginView: LoginViewType) {
        loginView.passwordLabel?.font = fontPalette.labels
        loginView.passwordLabel?.textColor = colorPalette.labels
        loginView.passwordTextField.font = fontPalette.textfields
        loginView.passwordTextField.textColor = colorPalette.textfieldText
        loginView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        loginView.passwordVisibilityButton?.titleLabel?.textColor = colorPalette.passwordVisibilityButtonText
    }
    
    private func configureLinksElements(loginView: LoginViewType) {
        loginView.recoverPasswordLabel?.font = fontPalette.labels
        loginView.recoverPasswordLabel?.textColor = colorPalette.labels
        loginView.recoverPasswordButton.titleLabel?.font = fontPalette.links
        loginView.recoverPasswordButton.titleLabel?.textColor = colorPalette.links
        
        loginView.signupLabel?.font = fontPalette.labels
        loginView.signupLabel?.textColor = colorPalette.labels
        loginView.signupButton.titleLabel?.font = fontPalette.links
        loginView.signupButton.titleLabel?.textColor = colorPalette.links
    }
    
    private func configureErrorElements(loginView: LoginViewType) {
        loginView.emailValidationMessageLabel?.font = fontPalette.labels
        loginView.emailValidationMessageLabel?.textColor = colorPalette.textfieldsError
        loginView.passwordValidationMessageLabel?.font = fontPalette.labels
        loginView.passwordValidationMessageLabel?.textColor = colorPalette.textfieldsError
        loginView.logInErrorLabel?.font = fontPalette.labels
        loginView.logInErrorLabel?.textColor = colorPalette.textfieldsError
    }
    
}
