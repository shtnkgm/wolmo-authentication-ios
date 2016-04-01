//
//  LoginColorPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct LoginColorPalette {

    public let logInButtonDisabled: UIColor
    public let logInButtonEnabled: UIColor
    public let logInButtonExecuted: UIColor
    
    public let textfieldsError: UIColor
    public let textfieldsNormal: UIColor
    public let textfieldsSelected: UIColor
    
    public let background: UIColor
    
    public let links: UIColor
    
    init() {
        logInButtonDisabled = UIColor(hexString: "#d8d8d8ff")!
        logInButtonEnabled = UIColor(hexString: "#f5a623ff")!
        logInButtonExecuted = UIColor(hexString: "#e78f00ff")!
        textfieldsError = UIColor(hexString: "#d0021bff")!
        textfieldsNormal = UIColor.clearColor()
        textfieldsSelected = UIColor.clearColor()
        background = UIColor(hexString: "#efefefff")!
        links = UIColor(hexString: "#0076ffff")!
    }
    
}
