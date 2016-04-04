//
//  RegisterViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol RegisterViewDelegate {
    
    var colourPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    func configureView(signupView: RegisterViewType)
    
}

public extension RegisterViewDelegate {
    
    func configureView(signupView: RegisterViewType) {
        
    }
    
}

public final class DefaultRegisterViewDelegate: RegisterViewDelegate {
    
    public let colourPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    
    public init() {
        colourPalette = DefaultColorPalette()
        fontPalette = DefaultFontPalette()
    }
    
    public init(configuration: SignupViewConfigurationType) {
        colourPalette = configuration.colourPalette
        fontPalette = configuration.fontPalette
    }
    
    public func configureView(signupView: RegisterViewType) {
        signupView.view.backgroundColor = colourPalette.background
        
        configureMainButton(signupView)
        configureUsernameElements(signupView)
        configureEmailElements(signupView)
        configurePasswordElements(signupView)
        configureLinksElements(signupView)
        configureErrorElements(signupView)
    }
    
    private func configureMainButton(signupView: RegisterViewType) {
        signupView.registerButton.backgroundColor = colourPalette.mainButtonDisabled
        signupView.registerButton.titleLabel?.font = fontPalette.mainButton
        signupView.registerButton.titleLabel?.textColor = colourPalette.mainButtonText
    }
    
    private func configureUsernameElements(signupView: RegisterViewType) {
        signupView.usernameLabel?.font = fontPalette.labels
        signupView.usernameLabel?.textColor = colourPalette.labels
        signupView.usernameTextField?.font = fontPalette.textfields
        signupView.usernameTextField?.textColor = colourPalette.textfieldText
    }
    
    private func configureEmailElements(signupView: RegisterViewType) {
        signupView.emailLabel?.font = fontPalette.labels
        signupView.emailLabel?.textColor = colourPalette.labels
        signupView.emailTextField.font = fontPalette.textfields
        signupView.emailTextField.textColor = colourPalette.textfieldText
    }
    
    private func configurePasswordElements(signupView: RegisterViewType) {
        signupView.passwordLabel?.font = fontPalette.labels
        signupView.passwordLabel?.textColor = colourPalette.labels
        signupView.passwordTextField.font = fontPalette.textfields
        signupView.passwordTextField.textColor = colourPalette.textfieldText
        signupView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordVisibilityButton?.titleLabel?.textColor = colourPalette.passwordVisibilityButtonText
        
        signupView.passwordConfirmLabel?.font = fontPalette.labels
        signupView.passwordConfirmLabel?.textColor = colourPalette.labels
        signupView.passwordConfirmTextField.font = fontPalette.textfields
        signupView.passwordConfirmTextField.textColor = colourPalette.textfieldText
        signupView.passwordConfirmVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordConfirmVisibilityButton?.titleLabel?.textColor = colourPalette.passwordVisibilityButtonText
    }
    
    private func configureLinksElements(signupView: RegisterViewType) {
        signupView.termsAndServicesLabel?.font = fontPalette.labels
        signupView.termsAndServicesLabel?.textColor = colourPalette.labels
        signupView.termsAndServicesButton.titleLabel?.font = fontPalette.links
        signupView.termsAndServicesButton.titleLabel?.textColor = colourPalette.links
    }
    
    private func configureErrorElements(signupView: RegisterViewType) {
        signupView.usernameValidationMessageLabel?.font = fontPalette.labels
        signupView.usernameValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.emailValidationMessageLabel?.font = fontPalette.labels
        signupView.emailValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.passwordValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.passwordConfirmValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordConfirmValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.registerErrorLabel?.font = fontPalette.labels
        signupView.registerErrorLabel?.textColor = colourPalette.textfieldsError
    }
    
}
