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
    
}

public final class DefaultSignupViewConfiguration: SignupViewConfigurationType {
    
    public let colorPalette: ColorPaletteType
    public let fontPalette: FontPaletteType
    
    public init(colorPalette: ColorPaletteType = DefaultColorPalette(),
                fontPalette: FontPaletteType = DefaultFontPalette()) {
        self.colorPalette = colorPalette
        self.fontPalette = fontPalette
    }
    
}
