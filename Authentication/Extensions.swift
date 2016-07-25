//
//  Extensions.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/25/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public extension String {
    
    public var frameworkBundle: NSBundle { return  NSBundle(forClass: LoginView.self) }
    
    /**
         Returns a localized representation of the string,
         searching first in the main bundle or if it does
         not have the key in the framework one if.
     */
    public var frameworkLocalized: String {
        let mainLocalized = NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        if mainLocalized == self {
            return NSLocalizedString(self, tableName: nil, bundle: frameworkBundle, value: "", comment: "")
        } else {
            return mainLocalized
        }
    }
    
    /**
         Returns a localized representation of the string.
         
         - parameter arguments: Formatting arguments.
     */
    public func frameworkLocalized(arguments: CVarArgType...) -> String {
        let mainLocalized = String(format: NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: ""), arguments: arguments)
        if mainLocalized == self {
            return String(format: NSLocalizedString(self, tableName: nil, bundle: frameworkBundle, value: "", comment: ""), arguments: arguments)
        } else {
            return mainLocalized
        }
    }
    
}
