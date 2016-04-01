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
    
    var colourPalette: LoginColorPalette { get }
    var fontPalette: LoginFontPalette { get }
    
    func configureView(loginView: LoginViewType)
    
}

public extension LoginViewDelegate {
    
    func configureView(loginView: LoginViewType) {
        
    }
    
}

public final class DefaultLoginViewDelegate: LoginViewDelegate {
    
    private let _configuration: LoginViewConfigurationType
    
    public let colourPalette: LoginColorPalette
    public let fontPalette: LoginFontPalette

    init() {
        _configuration = DefaultLoginViewConfiguration()
        colourPalette = LoginColorPalette()
        fontPalette = LoginFontPalette()
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
        
        loginView.logInButton.backgroundColor = colourPalette.logInButtonDisabled
        loginView.logInButton.titleLabel?.font = fontPalette.loginButton
        
        loginView.emailLabel?.font = fontPalette.labels
        loginView.emailTextField.font = fontPalette.textfields
        
        loginView.passwordLabel?.font = fontPalette.labels
        loginView.passwordTextField.font = fontPalette.textfields
        loginView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        
        loginView.recoverPasswordButton.titleLabel?.font = fontPalette.links
        
        loginView.registerLabel.font = fontPalette.labels
        loginView.registerButton.titleLabel?.font = fontPalette.links
    }
    
}
