//
//  SignupViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupViewConfigurationType {
    
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    // Must be consistent with the view used.
    var usernameEnabled: Bool { get }
    var passwordConfirmationEnabled: Bool { get }
    
}

public struct DefaultSignupViewConfiguration: SignupViewConfigurationType {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    public let usernameEnabled: Bool
    public let passwordConfirmationEnabled: Bool
    
    public init() {
        colorPalette = DefaultColorPalette()
        fontPalette = DefaultFontPalette()
        usernameEnabled = false
        passwordConfirmationEnabled = false
    }
    
}
