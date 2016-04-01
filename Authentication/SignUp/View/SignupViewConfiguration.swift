//
//  SignupViewConfiguration.swift
//  Authentication
//
//  Created by Daniela Riesgo on 4/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol SignupViewConfigurationType {
    
    var colourPalette: ColorPalette { get }
    var fontPalette: FontPalette { get }
    
}

public final class DefaultSignupViewConfiguration: SignupViewConfigurationType {
    
    public let colourPalette: ColorPalette
    public let fontPalette: FontPalette
    
    public init() {
        colourPalette = ColorPalette()
        fontPalette = FontPalette()
    }
    
}
