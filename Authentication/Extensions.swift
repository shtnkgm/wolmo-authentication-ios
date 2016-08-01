//
//  Extensions.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/25/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

internal extension String {
    
    /**
         Returns a localized representation of the string,
         searching first in the main bundle or if it does
         not have the key in the framework one.
     */
    internal var frameworkLocalized: String {
        let localized: (from: NSBundle) -> String = {
            NSLocalizedString(self, tableName: nil, bundle: $0, value: "", comment: "")
        }
        let mainLocalized = localized(from: NSBundle.mainBundle())
        return mainLocalized == self ? localized(from: FrameworkBundle) : mainLocalized
    }
    
    /**
         Returns a localized representation of the string,
         searching first in the main bundle or if it does
         not have the key in the framework one.
     
         - parameter arguments: Formatting arguments.
     */
    internal func frameworkLocalized(arguments: CVarArgType...) -> String {
        return String(format: frameworkLocalized, arguments: arguments)
    }
    
}

public extension UIButton {
    
    public func setUnderlinedTitle(title: String, style: NSUnderlineStyle = .StyleSingle, color: UIColor? = .None, forState state: UIControlState = .Normal) {
        var attributes: [String : AnyObject] = [NSUnderlineStyleAttributeName: style.rawValue]
        if let colorAttr = color {
            attributes[NSUnderlineColorAttributeName] = colorAttr
        }
        let underlinedText = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(underlinedText, forState: state)

    }
    
}
