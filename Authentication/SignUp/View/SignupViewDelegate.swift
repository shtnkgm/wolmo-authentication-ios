//
//  SignupViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupViewDelegate {
    
    var colourPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    func configureView(signupView: SignupViewType)
    
}

public extension SignupViewDelegate {
    
    func configureView(signupView: SignupViewType) {
        
    }
    
}

public final class DefaultSignupViewDelegate: SignupViewDelegate {
    
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
    
    public func configureView(signupView: SignupViewType) {
        signupView.view.backgroundColor = colourPalette.background
        
        configureMainButton(signupView)
        configureUsernameElements(signupView)
        configureEmailElements(signupView)
        configurePasswordElements(signupView)
        configureLinksElements(signupView)
        configureErrorElements(signupView)
    }
    
    private func configureMainButton(signupView: SignupViewType) {
        signupView.signupButton.backgroundColor = colourPalette.mainButtonDisabled
        signupView.signupButton.titleLabel?.font = fontPalette.mainButton
        signupView.signupButton.titleLabel?.textColor = colourPalette.mainButtonText
    }
    
    private func configureUsernameElements(signupView: SignupViewType) {
        signupView.usernameLabel?.font = fontPalette.labels
        signupView.usernameLabel?.textColor = colourPalette.labels
        signupView.usernameTextField?.font = fontPalette.textfields
        signupView.usernameTextField?.textColor = colourPalette.textfieldText
    }
    
    private func configureEmailElements(signupView: SignupViewType) {
        signupView.emailLabel?.font = fontPalette.labels
        signupView.emailLabel?.textColor = colourPalette.labels
        signupView.emailTextField.font = fontPalette.textfields
        signupView.emailTextField.textColor = colourPalette.textfieldText
    }
    
    private func configurePasswordElements(signupView: SignupViewType) {
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
    
    private func configureLinksElements(signupView: SignupViewType) {
        signupView.termsAndServicesLabel?.font = fontPalette.labels
        signupView.termsAndServicesLabel?.textColor = colourPalette.labels
        signupView.termsAndServicesButton.titleLabel?.font = fontPalette.links
        signupView.termsAndServicesButton.titleLabel?.textColor = colourPalette.links
    }
    
    private func configureErrorElements(signupView: SignupViewType) {
        signupView.usernameValidationMessageLabel?.font = fontPalette.labels
        signupView.usernameValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.emailValidationMessageLabel?.font = fontPalette.labels
        signupView.emailValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.passwordValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.passwordConfirmValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordConfirmValidationMessageLabel?.textColor = colourPalette.textfieldsError
        signupView.signupErrorLabel?.font = fontPalette.labels
        signupView.signupErrorLabel?.textColor = colourPalette.textfieldsError
    }
    
}
