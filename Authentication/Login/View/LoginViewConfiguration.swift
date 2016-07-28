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
 
    Includes the font and color palettes,
    and the logo image.
*/
public protocol LoginViewConfigurationType {
    
    var logoImage: UIImage? { get }
    var colorPalette: ColorPaletteType { get }
    var fontPalette: FontPaletteType { get }
    
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
    
    public init(logoImage: UIImage? = .None,
                colorPalette: ColorPaletteType = DefaultColorPalette(),
                fontPalette: FontPaletteType = DefaultFontPalette()) {
        self.logoImage = logoImage
        self.colorPalette = colorPalette
        self.fontPalette = fontPalette
    }
    
}
