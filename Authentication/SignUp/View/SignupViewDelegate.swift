//
//  SignupViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupViewDelegate {
    
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
    func configureView(signupView: SignupViewType)
    
}

public extension SignupViewDelegate {
    
    func configureView(signupView: SignupViewType) { }
    
}

public final class DefaultSignupViewDelegate: SignupViewDelegate {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    
    public init(configuration: SignupViewConfigurationType = DefaultSignupViewConfiguration()) {
        colorPalette = configuration.colorPalette
        fontPalette = configuration.fontPalette
    }
    
    public func configureView(signupView: SignupViewType) {
        signupView.view.backgroundColor = colorPalette.background
        signupView.titleLabel.textColor = colorPalette.labels
        signupView.titleLabel.font = fontPalette.mainButton
        
        configureMainButton(signupView)
        configureUsernameElements(signupView)
        configureEmailElements(signupView)
        configurePasswordElements(signupView)
        configureLinksElements(signupView)
        configureErrorElements(signupView)
    }
    
    private func configureMainButton(signupView: SignupViewType) {
        signupView.signupButton.backgroundColor = colorPalette.mainButtonDisabled
        signupView.signupButton.titleLabel?.font = fontPalette.mainButton
        signupView.signupButton.titleLabel?.textColor = colorPalette.mainButtonText
    }
    
    private func configureUsernameElements(signupView: SignupViewType) {
        signupView.usernameLabel?.font = fontPalette.labels
        signupView.usernameLabel?.textColor = colorPalette.labels
        signupView.usernameTextField?.font = fontPalette.textfields
        signupView.usernameTextField?.textColor = colorPalette.textfieldText
    }
    
    private func configureEmailElements(signupView: SignupViewType) {
        signupView.emailLabel?.font = fontPalette.labels
        signupView.emailLabel?.textColor = colorPalette.labels
        signupView.emailTextField.font = fontPalette.textfields
        signupView.emailTextField.textColor = colorPalette.textfieldText
    }
    
    private func configurePasswordElements(signupView: SignupViewType) {
        signupView.passwordLabel?.font = fontPalette.labels
        signupView.passwordLabel?.textColor = colorPalette.labels
        signupView.passwordTextField.font = fontPalette.textfields
        signupView.passwordTextField.textColor = colorPalette.textfieldText
        signupView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordVisibilityButton?.titleLabel?.textColor = colorPalette.passwordVisibilityButtonText
        
        signupView.passwordConfirmLabel?.font = fontPalette.labels
        signupView.passwordConfirmLabel?.textColor = colorPalette.labels
        signupView.passwordConfirmTextField?.font = fontPalette.textfields
        signupView.passwordConfirmTextField?.textColor = colorPalette.textfieldText
        signupView.passwordConfirmVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordConfirmVisibilityButton?.titleLabel?.textColor = colorPalette.passwordVisibilityButtonText
    }
    
    private func configureLinksElements(signupView: SignupViewType) {
        signupView.termsAndServicesLabel?.font = fontPalette.labels
        signupView.termsAndServicesLabel?.textColor = colorPalette.labels
        signupView.termsAndServicesButton.titleLabel?.font = fontPalette.links
        signupView.termsAndServicesButton.titleLabel?.textColor = colorPalette.links
    }
    
    private func configureErrorElements(signupView: SignupViewType) {
        signupView.usernameValidationMessageLabel?.font = fontPalette.labels
        signupView.usernameValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.emailValidationMessageLabel?.font = fontPalette.labels
        signupView.emailValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.passwordValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.passwordConfirmValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordConfirmValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.signupErrorLabel?.font = fontPalette.labels
        signupView.signupErrorLabel?.textColor = colorPalette.textfieldsError
    }
    
}
