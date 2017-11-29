//
//  ButtonConfiguration.swift
//  Authentication
//
//  Created by Argentino Ducret on 7/31/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation

/**
     Represents the login button and Signup button configuration.
 */

public protocol ButtonConfigurationType {
    
    var cornerRadius: CGFloat { get }
    
}

public extension ButtonConfigurationType {
    
    var cornerRadius: CGFloat { return 0.0 }
    
}

public struct DefaultButtonConfiguration: ButtonConfigurationType {
    public init() { }
}
