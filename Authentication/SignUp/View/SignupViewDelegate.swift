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
public protocol SignupViewDelegate {    //swiftlint:disable:this class_delegate_protocol
    
    /** Palettes ued to configure all login view elements possible. */
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    var termsAndServicesURL: URL { get }
    var showLoginProviders: Bool { get }
    
    /**
        Function to configure all view elements according to the palettes.
        It is called by the default signup view when rendered.
        
        By default, does nothing.
     */
    func configureSignupView(_ signupView: SignupViewType)
    
}

public extension SignupViewDelegate {
    
    func configureSignupView(_ signupView: SignupViewType) { }
    
}

/**
     The default signup view delegate takes care of
     setting all SignupViewType elements possible according to palettes.
 */
public final class DefaultSignupViewDelegate: SignupViewDelegate {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    public let termsAndServicesURL: URL
    public let showLoginProviders: Bool
    
    internal init(configuration: SignupViewConfigurationType) {
        colorPalette = configuration.colorPalette
        fontPalette = configuration.fontPalette
        termsAndServicesURL = configuration.termsAndServicesURL
        showLoginProviders = configuration.showLoginProviders
    }
    
    internal convenience init(termsAndServicesURL: URL) {
        self.init(configuration: SignupViewConfiguration(termsAndServicesURL: termsAndServicesURL))
    }
    
    public func configureSignupView(_ signupView: SignupViewType) {
        signupView.view.backgroundColor = colorPalette.background
        signupView.titleLabel.textColor = colorPalette.labels
        signupView.titleLabel.font = fontPalette.mainButton
        
        configureMainButton(in: signupView)
        configureUsernameElements(in: signupView)
        configureEmailElements(in: signupView)
        configurePasswordElements(in: signupView)
        configureLinksElements(in: signupView)
        configureErrorElements(in: signupView)
    }

}

fileprivate extension DefaultSignupViewDelegate {

    fileprivate func configureMainButton(in signupView: SignupViewType) {
        signupView.signUpButton.backgroundColor = colorPalette.mainButtonDisabled
        signupView.signUpButton.titleLabel?.font = fontPalette.mainButton
        signupView.signUpButton.titleLabel?.textColor = colorPalette.mainButtonText
    }
    
    fileprivate func configureUsernameElements(in signupView: SignupViewType) {
        signupView.usernameLabel?.font = fontPalette.labels
        signupView.usernameLabel?.textColor = colorPalette.labels
        signupView.usernameTextField?.font = fontPalette.textfields
        signupView.usernameTextField?.textColor = colorPalette.textfieldText
        signupView.usernameTextField?.backgroundColor = colorPalette.textfieldBackground
        signupView.usernameTextField?.tintColor = colorPalette.textfieldTint
    }
    
    fileprivate func configureEmailElements(in signupView: SignupViewType) {
        signupView.emailLabel?.font = fontPalette.labels
        signupView.emailLabel?.textColor = colorPalette.labels
        signupView.emailTextField.font = fontPalette.textfields
        signupView.emailTextField.textColor = colorPalette.textfieldText
        signupView.emailTextField.backgroundColor = colorPalette.textfieldBackground
        signupView.emailTextField.tintColor = colorPalette.textfieldTint
    }
    
    fileprivate func configurePasswordElements(in signupView: SignupViewType) {
        signupView.passwordLabel?.font = fontPalette.labels
        signupView.passwordLabel?.textColor = colorPalette.labels
        signupView.passwordTextField.font = fontPalette.textfields
        signupView.passwordTextField.textColor = colorPalette.textfieldText
        signupView.passwordTextField.tintColor = colorPalette.textfieldTint
        signupView.passwordVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordVisibilityButton?.setTitleColor(colorPalette.passwordVisibilityButtonText, for: .normal)
        signupView.passwordConfirmLabel?.font = fontPalette.labels
        signupView.passwordConfirmLabel?.textColor = colorPalette.labels
        signupView.passwordConfirmTextField?.font = fontPalette.textfields
        signupView.passwordConfirmTextField?.textColor = colorPalette.textfieldText
        signupView.passwordConfirmTextField?.tintColor = colorPalette.textfieldTint
        signupView.passwordConfirmVisibilityButton?.titleLabel?.font = fontPalette.passwordVisibilityButton
        signupView.passwordConfirmVisibilityButton?.setTitleColor(colorPalette.passwordVisibilityButtonText, for: .normal)
    }
    
    fileprivate func configureLinksElements(in signupView: SignupViewType) {
        signupView.setTermsAndServicesText(withURL: termsAndServicesURL)
        signupView.termsAndServicesTextView.textColor = colorPalette.labels
        signupView.termsAndServicesTextView.font = fontPalette.labels
        
        signupView.loginLabel?.font = fontPalette.labels
        signupView.loginLabel?.textColor = colorPalette.labels
        signupView.loginButton.titleLabel?.font = fontPalette.links
        signupView.loginButton.titleLabel?.textColor = colorPalette.links
    }
    
    fileprivate func configureErrorElements(in signupView: SignupViewType) {
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
