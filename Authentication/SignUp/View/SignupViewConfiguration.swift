//
//  SignupViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents the configurable parameters
     of a view that conforms to SignupViewType.
 */
public protocol SignupViewConfigurationType {
    
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    var buttonCofinguration: ButtonConfigurationType { get }
    
    /// NSURL from where to get the HTML content that displays the terms and services.
    var termsAndServicesURL: URL { get }
    
    // Textfield selected must be consistent with the view used.
    var usernameEnabled: Bool { get }
    var passwordConfirmationEnabled: Bool { get }
    
    var showLoginProviders: Bool { get }
    
}

/**
    The SignupViewConfiguration stores all palettes
    and decisions necessary.
 
    By default, it uses the default palettes and
    doesn't include optional textfields.
 */
public struct SignupViewConfiguration: SignupViewConfigurationType {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    public let buttonCofinguration: ButtonConfigurationType
    public let termsAndServicesURL: URL
    public let usernameEnabled: Bool
    public let passwordConfirmationEnabled: Bool
    public let showLoginProviders: Bool
    
    public init(termsAndServicesURL: URL,
                colorPalette: ColorPaletteType = DefaultColorPalette(),
                fontPalette: FontPaletteType = DefaultFontPalette(),
                buttonConfiguration: ButtonConfigurationType = DefaultButtonConfiguration(),
                usernameEnabled: Bool = false,
                passwordConfirmationEnabled: Bool = false,
                showLoginProviders: Bool = true) {
        self.termsAndServicesURL = termsAndServicesURL
        self.colorPalette = colorPalette
        self.fontPalette = fontPalette
        self.buttonCofinguration = buttonConfiguration
        self.usernameEnabled = usernameEnabled
        self.passwordConfirmationEnabled = passwordConfirmationEnabled
        self.showLoginProviders = showLoginProviders
    }
    
}
