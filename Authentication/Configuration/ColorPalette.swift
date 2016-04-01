//
//  ColorPalette.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/31/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public struct ColorPalette {

    public let mainButtonDisabled: UIColor
    public let mainButtonEnabled: UIColor
    public let mainButtonExecuted: UIColor
    
    public let textfieldsError: UIColor
    public let textfieldsNormal: UIColor
    public let textfieldsSelected: UIColor
    
    public let background: UIColor
    
    public let links: UIColor
    public let labels: UIColor
    public let textfieldText: UIColor
    public let passwordVisibilityButtonText: UIColor
    public let mainButtonText: UIColor
    
    init() {
        mainButtonDisabled = UIColor(hexString: "#d8d8d8ff")!
        mainButtonEnabled = UIColor(hexString: "#f5a623ff")!
        mainButtonExecuted = UIColor(hexString: "#e78f00ff")!
        textfieldsError = UIColor(hexString: "#d0021bff")!
        textfieldsNormal = UIColor.clearColor()
        textfieldsSelected = UIColor.clearColor()
        background = UIColor(hexString: "#efefefff")!
        links = UIColor(hexString: "#0076ffff")!
        labels = UIColor.blackColor()
        textfieldText = UIColor.blackColor()
        passwordVisibilityButtonText = links
        mainButtonText = UIColor.whiteColor()
    }
    
}
