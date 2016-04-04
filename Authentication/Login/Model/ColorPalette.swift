//
//  ColorPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol ColorPaletteType {
    
    var logInButtonDisabled: UIColor { get }
    var logInButtonEnabled: UIColor { get }
    var logInButtonExecuted: UIColor { get }
    
    var textfieldsError: UIColor { get }
    var textfieldsNormal: UIColor { get }
    var textfieldsSelected: UIColor { get }
    
    var background: UIColor { get }
    
    var links: UIColor { get }
    
}

public extension ColorPaletteType {
    
    public var logInButtonDisabled: UIColor { return UIColor(hexString: "#d8d8d8ff")! }
    public var logInButtonEnabled: UIColor { return UIColor(hexString: "#f5a623ff")! }
    public var logInButtonExecuted: UIColor { return UIColor(hexString: "#e78f00ff")! }
    
    public var textfieldsError: UIColor { return UIColor(hexString: "#d0021bff")! }
    public var textfieldsNormal: UIColor { return UIColor.clearColor() }
    public var textfieldsSelected: UIColor { return UIColor.clearColor() }
    
    public var background: UIColor { return UIColor(hexString: "#efefefff")! }
    
    public var links: UIColor { return UIColor(hexString: "#0076ffff")! }

    
}

public struct DefaultColorPalette: ColorPaletteType { }
