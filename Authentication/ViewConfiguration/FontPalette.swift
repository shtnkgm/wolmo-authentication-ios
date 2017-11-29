//
//  FontPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Represents the font hierarchy necessary for
     an authentication view.
 
     All fonts used should be from the same family
     for style coherence.
 */
public protocol FontPaletteType {
    
    var textfields: UIFont { get }
    var passwordVisibilityButton: UIFont { get }
    // Links refers to any navigational button or
    // link present in the view.
    var links: UIFont { get }
    var labels: UIFont { get }
    var mainButton: UIFont { get }
    
}

/** By default, the FontPalette uses the SystemFont family, and
 only highlights the main button text with bigger and bold font. */
public extension FontPaletteType {
    
    public var textfields: UIFont { return .systemFont(ofSize: 14) }
    public var passwordVisibilityButton: UIFont { return .systemFont(ofSize: 14) }
    public var links: UIFont { return .systemFont(ofSize: 14) }
    public var labels: UIFont { return .systemFont(ofSize: 14) }
    public var mainButton: UIFont { return .boldSystemFont(ofSize: 16) }
    
}

public struct DefaultFontPalette: FontPaletteType {
    public init() { }
}
