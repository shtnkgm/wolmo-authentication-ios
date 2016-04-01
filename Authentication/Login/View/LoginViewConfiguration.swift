//
//  LoginViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct LoginViewConfiguration {
    
    public let logoImage: UIImage?
    public let colourPalette: LoginColourPalette
    public let fontPalette: LoginFontPalette
    
    public init() {
        logoImage = .None
        colourPalette = LoginColourPalette()
        fontPalette = LoginFontPalette()
    }
    
    public init(logoImage: UIImage?) {
        self.logoImage = logoImage
        colourPalette = LoginColourPalette()
        fontPalette = LoginFontPalette()
    }
    
}
