//
//  SignupView+LocalizedTexts.swift
//  Authentication
//
//  Created by Daniela Riesgo on 5/12/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation

// MARK: - strings extension
public extension SignupViewType {

    public var titleText: String { return "signup-view.title".frameworkLocalized }

    public var usernameText: String { return "signup-view.username".frameworkLocalized }

    public var emailText: String { return "signup-view.email".frameworkLocalized }

    public var passwordText: String { return "signup-view.password".frameworkLocalized }

    public var confirmPasswordText: String { return "signup-view.confirm-password".frameworkLocalized }

    public var usernamePlaceholderText: String { return "signup-view.username-placeholder".frameworkLocalized}

    public var emailPlaceholderText: String { return "signup-view.email-placeholder".frameworkLocalized }

    public var passwordPlaceholderText: String { return "signup-view.password-placeholder".frameworkLocalized }

    public var confirmPasswordPlaceholderText: String { return "signup-view.confirm-password-placeholder".frameworkLocalized }

    public var passwordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (passwordVisible ? "false" : "true")).frameworkLocalized }

    public var confirmPasswordVisibilityButtonTitle: String { return ("text-visibility-button-title." + (passwordConfirmationVisible ? "false" : "true")).frameworkLocalized }

    public var termsAndServicesText: String { return "signup-view.terms-and-services.text".frameworkLocalized }

    public var termsAndServicesLinkText: String { return "signup-view.terms-and-services.link-text".frameworkLocalized }

    public var signUpButtonTitle: String { return "signup-view.signup-button-title".frameworkLocalized }

    public var loginLabelText: String { return "signup-view.login.label-text".frameworkLocalized }

    public var loginButtonTitle: String { return "signup-view.login.button-title".frameworkLocalized }

}
