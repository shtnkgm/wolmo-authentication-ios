//
//  ColorPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents the color hierarchy necessary for
     an authentication view.
 */
public protocol ColorPaletteType {
    
    var background: UIColor { get }
    
    var mainButtonDisabled: UIColor { get }
    var mainButtonEnabled: UIColor { get }
    var mainButtonExecuted: UIColor { get }
    
    var textfieldsError: UIColor { get }
    var textfieldsNormal: UIColor { get }
    var textfieldsSelected: UIColor { get }
    
    // Links refers to any navigational button or
    // link present in the view.
    var links: UIColor { get }
    var labels: UIColor { get }
    var textfieldText: UIColor { get }
    var textfieldBackground: UIColor { get }
    var passwordVisibilityButtonText: UIColor { get }
    var mainButtonText: UIColor { get }
    
}

public extension ColorPaletteType {
    
    public var mainButtonDisabled: UIColor { return UIColor(hex: "#d8d8d8ff")! }
    public var mainButtonEnabled: UIColor { return UIColor(hex: "#f5a623ff")! }
    public var mainButtonExecuted: UIColor { return UIColor(hex: "#e78f00ff")! }
    
    public var textfieldsError: UIColor { return UIColor(hex: "#d0021bff")! }
    public var textfieldsNormal: UIColor { return .clear }
    public var textfieldsSelected: UIColor { return .clear }
    
    public var background: UIColor { return UIColor(hex: "#efefefff")! }
    
    public var links: UIColor { return UIColor(hex: "#0076ffff")! }
    public var labels: UIColor { return .black }
    public var textfieldText: UIColor { return .black }
    public var textfieldBackground: UIColor { return .white }
    public var passwordVisibilityButtonText: UIColor { return UIColor(hex: "#0076ffff")! }
    public var mainButtonText: UIColor { return .white }
    
}

public struct DefaultColorPalette: ColorPaletteType { }
