//
//  FontPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
    All fonts used should be from the same family
    for style coherence.
*/
public protocol FontPaletteType {
    
    var textfields: UIFont { get }
    var passwordVisibilityButton: UIFont { get }
    var links: UIFont { get }
    var labels: UIFont { get }
    var loginButton: UIFont { get }
    
}

public extension FontPaletteType {
    
    public var textfields: UIFont { return UIFont.systemFontOfSize(14) }
    public var passwordVisibilityButton: UIFont { return UIFont.systemFontOfSize(14) }
    public var links: UIFont { return UIFont.systemFontOfSize(14) }
    public var labels: UIFont { return UIFont.systemFontOfSize(14) }
    public var loginButton: UIFont { return UIFont.boldSystemFontOfSize(16) }
    
    
}

public struct DefaultFontPalette: FontPaletteType { }
