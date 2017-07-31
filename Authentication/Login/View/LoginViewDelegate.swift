//
//  LoginViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
    Delegate for any extra configuration
    to the login view when rendered.
*/
public protocol LoginViewDelegate { //swiftlint:disable:this class_delegate_protocol
    
    /** Palettes used to configure all login view elements possible. */
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    /**
        Function to configure all view elements according to the palettes.
        It is called by the default login view when rendered.
     
        By default, does nothing.
     
        - Parameter loginView: view to configure.
     */
    func configureLoginView(_ loginView: LoginViewType)
    
}

public extension LoginViewDelegate {
    
    public func configureLoginView(_ loginView: LoginViewType) { }
    
}

/**
    The default login view delegate takes care of:
       setting the logo image according to the configuration and
       setting all LoginViewType elements possible according to palettes.
*/
public final class DefaultLoginViewDelegate: LoginViewDelegate {
    
    private let _configuration: LoginViewConfigurationType

    public var colorPalette: ColorPaletteType { return _configuration.colorPalette }
    public var fontPalette: FontPaletteType { return _configuration.fontPalette }
    
    internal init(configuration: LoginViewConfigurationType = LoginViewConfiguration()) {
        _configuration = configuration
    }
    
    public func configureLoginView(_ loginView: LoginViewType) {
        if let logo = _configuration.logoImage {
            loginView.logoImageView.image = logo
        }
        
        loginView.view.backgroundColor = colorPalette.background
        
        configureMainButton(in: loginView)
        configureEmailElements(in: loginView)
        configurePasswordElements(in: loginView)
        configureLinksElements(in: loginView)
        configureErrorElements(in: loginView)
    }

}

fileprivate extension DefaultLoginViewDelegate {

    fileprivate func configureMainButton(in loginView: LoginViewType) {
        loginView.logInButton.backgroundColor = colorPalette.mainButtonDisabled
        loginView.logInButton.titleLabel?.font = fontPalette.mainButton
        loginView.logInButton.titleLabel?.textColor = colorPalette.mainButtonText
    }
    
    fileprivate func configureEmailElements(in loginView: LoginViewType) {
        loginView.emailLabel?.font = fontPalette.labels
        loginView.emailLabel?.textColor = colorPalette.labels
        loginView.emailTextField.font = fontPalette.textfields
        loginView.emailTextField.textColor = colorPalette.textfieldText
    }
    
    fileprivate func configurePasswordElements(in loginView: LoginViewType) {
        loginView.passwordLabel?.font = fontPalette.labels
        loginView.passwordLabel?.textColor = colorPalette.labels
        loginView.passwordTextField.font = fontPalette.textfields
        loginView.passwordTextField.textColor = colorPalette.textfieldText
        loginView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        loginView.passwordVisibilityButton?.setTitleColor(colorPalette.passwordVisibilityButtonText, for: .normal)
    }
    
    fileprivate func configureLinksElements(in loginView: LoginViewType) {
        loginView.recoverPasswordLabel?.font = fontPalette.labels
        loginView.recoverPasswordLabel?.textColor = colorPalette.labels
        loginView.recoverPasswordButton.titleLabel?.font = fontPalette.links
        loginView.recoverPasswordButton.titleLabel?.textColor = colorPalette.links
        
        loginView.signupLabel?.font = fontPalette.labels
        loginView.signupLabel?.textColor = colorPalette.labels
        loginView.signupButton.titleLabel?.font = fontPalette.links
        loginView.signupButton.titleLabel?.textColor = colorPalette.links
    }
    
    fileprivate func configureErrorElements(in loginView: LoginViewType) {
        loginView.emailValidationMessageLabel?.font = fontPalette.labels
        loginView.emailValidationMessageLabel?.textColor = colorPalette.textfieldsError
        loginView.passwordValidationMessageLabel?.font = fontPalette.labels
        loginView.passwordValidationMessageLabel?.textColor = colorPalette.textfieldsError
        loginView.logInErrorLabel?.font = fontPalette.labels
        loginView.logInErrorLabel?.textColor = colorPalette.textfieldsError
    }
    
}
