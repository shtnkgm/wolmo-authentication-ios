//
//  SignupViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Delegate for any extra configuration
     to the signup view when rendered.
 */
public protocol SignupViewDelegate {
    
    /** Palettes ued to configure all login view elements possible. */
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    var termsAndServicesURL: URL { get }
    
    /**
        Function to configure all view elements according to the palettes.
        It is called by the default signup view when rendered.
        
        By default, does nothing.
     */
    func configureView(_ signupView: SignupViewType)
    
}

public extension SignupViewDelegate {
    
    func configureView(_ signupView: SignupViewType) { }
    
}

/**
     The default signup view delegate takes care of
     setting all SignupViewType elements possible according to palettes.
 */
public final class DefaultSignupViewDelegate: SignupViewDelegate {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    public let termsAndServicesURL: URL
    
    internal init(configuration: SignupViewConfigurationType) {
        colorPalette = configuration.colorPalette
        fontPalette = configuration.fontPalette
        termsAndServicesURL = configuration.termsAndServicesURL as URL
    }
    
    internal convenience init(termsAndServicesURL: URL) {
        self.init(configuration: SignupViewConfiguration(termsAndServicesURL: termsAndServicesURL))
    }
    
    public func configureView(_ signupView: SignupViewType) {
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
    
    fileprivate func configureMainButton(_ signupView: SignupViewType) {
        signupView.signUpButton.backgroundColor = colorPalette.mainButtonDisabled
        signupView.signUpButton.titleLabel?.font = fontPalette.mainButton
        signupView.signUpButton.titleLabel?.textColor = colorPalette.mainButtonText
    }
    
    fileprivate func configureUsernameElements(_ signupView: SignupViewType) {
        signupView.usernameLabel?.font = fontPalette.labels
        signupView.usernameLabel?.textColor = colorPalette.labels
        signupView.usernameTextField?.font = fontPalette.textfields
        signupView.usernameTextField?.textColor = colorPalette.textfieldText
    }
    
    fileprivate func configureEmailElements(_ signupView: SignupViewType) {
        signupView.emailLabel?.font = fontPalette.labels
        signupView.emailLabel?.textColor = colorPalette.labels
        signupView.emailTextField.font = fontPalette.textfields
        signupView.emailTextField.textColor = colorPalette.textfieldText
    }
    
    fileprivate func configurePasswordElements(_ signupView: SignupViewType) {
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
    
    fileprivate func configureLinksElements(_ signupView: SignupViewType) {
        signupView.setTermsAndServicesText(termsAndServicesURL)
        signupView.termsAndServicesTextView.textColor = colorPalette.labels
        signupView.termsAndServicesTextView.font = fontPalette.labels
        
        signupView.loginLabel?.font = fontPalette.labels
        signupView.loginLabel?.textColor = colorPalette.labels
        signupView.loginButton.titleLabel?.font = fontPalette.links
        signupView.loginButton.titleLabel?.textColor = colorPalette.links
    }
    
    fileprivate func configureErrorElements(_ signupView: SignupViewType) {
        signupView.usernameValidationMessageLabel?.font = fontPalette.labels
        signupView.usernameValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.emailValidationMessageLabel?.font = fontPalette.labels
        signupView.emailValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.passwordValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.passwordConfirmValidationMessageLabel?.font = fontPalette.labels
        signupView.passwordConfirmValidationMessageLabel?.textColor = colorPalette.textfieldsError
        signupView.signUpErrorLabel?.font = fontPalette.labels
        signupView.signUpErrorLabel?.textColor = colorPalette.textfieldsError
    }
    
}
