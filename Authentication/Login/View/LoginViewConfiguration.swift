//
//  LoginViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
    Represents the configurable parameters
    of a view that conforms to LoginViewType.
*/
public protocol LoginViewConfigurationType {
    
    var logoImage: UIImage? { get }
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    var buttonConfiguration: ButtonConfigurationType { get }
    
}

/**
     The LoginViewConfiguration stores all palettes
     and logo necessary.
 
     By default, it uses the default palettes and
     doesn't include a logo.
 */
public struct LoginViewConfiguration: LoginViewConfigurationType {
    
    public let logoImage: UIImage?
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    public let buttonConfiguration: ButtonConfigurationType
    
    public init(logoImage: UIImage? = .none,
                colorPalette: ColorPaletteType = DefaultColorPalette(),
                fontPalette: FontPaletteType = DefaultFontPalette(),
                buttonConfiguration: ButtonConfigurationType = DefaultButtonConfiguration()) {
        self.logoImage = logoImage
        self.colorPalette = colorPalette
        self.fontPalette = fontPalette
        self.buttonConfiguration = buttonConfiguration
    }
    
}
