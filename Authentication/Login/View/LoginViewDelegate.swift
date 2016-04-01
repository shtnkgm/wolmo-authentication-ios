//
//  LoginViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
    Delegate for any extra configuration
    to the login view when rendered.
*/
public protocol LoginViewDelegate {
    
    var colourPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    func configureView(loginView: LoginViewType)
    
}

public extension LoginViewDelegate {
    
    func configureView(loginView: LoginViewType) {
        
    }
    
}

public final class DefaultLoginViewDelegate: LoginViewDelegate {
    
    private let _configuration: LoginViewConfigurationType

    public let colourPalette: ColorPaletteType
    public let fontPalette: FontPaletteType

    init() {
        _configuration = DefaultLoginViewConfiguration()
        colourPalette = DefaultColorPalette()
        fontPalette = DefaultFontPalette()
    }
    
    init(configuration: LoginViewConfigurationType) {
        _configuration = configuration
        colourPalette = configuration.colourPalette
        fontPalette = configuration.fontPalette
    }
    
    public func configureView(loginView: LoginViewType) {
        if let logo = _configuration.logoImage {
            loginView.logoImageView.image = logo
        }
        
        loginView.view.backgroundColor = colourPalette.background
        
        configureMainButton(loginView)
        configureEmailElements(loginView)
        configurePasswordElements(loginView)
        configureLinksElements(loginView)
        configureErrorElements(loginView)
    }
    
    private func configureMainButton(loginView: LoginViewType) {
        loginView.logInButton.backgroundColor = colourPalette.mainButtonDisabled
        loginView.logInButton.titleLabel?.font = fontPalette.mainButton
        loginView.logInButton.titleLabel?.textColor = colourPalette.mainButtonText
    }
    
    private func configureEmailElements(loginView: LoginViewType) {
        loginView.emailLabel?.font = fontPalette.labels
        loginView.emailLabel?.textColor = colourPalette.labels
        loginView.emailTextField.font = fontPalette.textfields
        loginView.emailTextField.textColor = colourPalette.textfieldText
    }
    
    private func configurePasswordElements(loginView: LoginViewType) {
        loginView.passwordLabel?.font = fontPalette.labels
        loginView.passwordLabel?.textColor = colourPalette.labels
        loginView.passwordTextField.font = fontPalette.textfields
        loginView.passwordTextField.textColor = colourPalette.textfieldText
        loginView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        loginView.passwordVisibilityButton?.titleLabel?.textColor = colourPalette.passwordVisibilityButtonText
    }
    
    private func configureLinksElements(loginView: LoginViewType) {
        loginView.recoverPasswordButton.titleLabel?.font = fontPalette.links
        loginView.recoverPasswordButton.titleLabel?.textColor = colourPalette.links
        
        loginView.registerLabel.font = fontPalette.labels
        loginView.registerLabel.textColor = colourPalette.labels
        loginView.registerButton.titleLabel?.font = fontPalette.links
        loginView.registerButton.titleLabel?.textColor = colourPalette.links
    }
    
    private func configureErrorElements(loginView: LoginViewType) {
        loginView.emailValidationMessageLabel?.font = fontPalette.labels
        loginView.emailValidationMessageLabel?.textColor = colourPalette.textfieldsError
        loginView.passwordValidationMessageLabel?.font = fontPalette.labels
        loginView.passwordValidationMessageLabel?.textColor = colourPalette.textfieldsError
        loginView.logInErrorLabel?.font = fontPalette.labels
        loginView.logInErrorLabel?.textColor = colourPalette.textfieldsError
    }
    
}
