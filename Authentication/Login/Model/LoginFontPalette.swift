//
//  LoginFontPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct LoginFontPalette {
    
    public let textfields: UIFont
    public let passwordVisibilityButton: UIFont
    public let links: UIFont
    public let labels: UIFont
    public let loginButton: UIFont
    
    init() {
        textfields = UIFont.systemFontOfSize(14)
        passwordVisibilityButton = UIFont.systemFontOfSize(14)
        links = UIFont.systemFontOfSize(14)
        labels = UIFont.systemFontOfSize(14)
        loginButton = UIFont.boldSystemFontOfSize(16)
    }
    
}
