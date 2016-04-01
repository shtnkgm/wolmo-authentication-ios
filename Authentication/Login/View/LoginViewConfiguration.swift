//
//  LoginViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol LoginViewConfigurationType {
    
    var logoImage: UIImage? { get }
    var colourPalette: LoginColorPalette { get }
    var fontPalette: LoginFontPalette { get }

    
}

public final class DefaultLoginViewConfiguration: LoginViewConfigurationType {
    
    public let logoImage: UIImage?
    public let colourPalette: LoginColorPalette
    public let fontPalette: LoginFontPalette
    
    public init() {
        logoImage = .None
        colourPalette = LoginColorPalette()
        fontPalette = LoginFontPalette()
    }
    
    public init(logoImage: UIImage?) {
        self.logoImage = logoImage
        colourPalette = LoginColorPalette()
        fontPalette = LoginFontPalette()
    }
    
}
