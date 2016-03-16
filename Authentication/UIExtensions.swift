//
//  UIExtensions.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol ActionHandlerType {}

extension ActionHandlerType where Self: UIControl {
    
    public func setAction(events: UIControlEvents = .TouchUpInside, _ action: Self -> Void) {
        let handler = ActionHandler(action: action)
        self.addTarget(handler, action: "action:", forControlEvents: events)
        objc_setAssociatedObject(self, actionHandlerTypeAssociatedObjectKey, handler, .OBJC_ASSOCIATION_RETAIN)
    }
    
}

extension UIControl: ActionHandlerType {}

private let actionHandlerTypeAssociatedObjectKey = UnsafeMutablePointer<Int8>.alloc(1)

private class ActionHandler<T>: NSObject {
    private let action: T -> Void
    
    init(action: T -> Void) {
        self.action = action
    }
    
    @objc func action(sender: UIControl) {
        if sender is T {
            action(sender)
        }
    }
    
}


public enum NibIdentifier: String {
    case LoginView = "LoginView"
}

extension UIView {
    
    /**
     Loads the nib for the specific view. If called without specifying the identifier, it will use the view name as the xib name.
     
     - parameter identifier: View's xib identifier, default = nil.
     - parameter bundle: Specific bundle, default = nil.
     
     - returns: The loaded UIView
     */
    class func loadFromNib<T: UIView, Identifier: RawRepresentable where Identifier.RawValue == String>(identifier: Identifier? = .None, bundle: NSBundle = NSBundle.mainBundle()) -> T {
        // swiftlint:disable force_cast
        let nibName = identifier?.rawValue ?? NSStringFromClass(self).componentsSeparatedByString(".").last!
        return bundle.loadNib(nibName) as! T
        // swiftlint:enable force_cast
    }
    
    class func loadFromNib<T: UIView>(bundle: NSBundle = NSBundle.mainBundle()) -> T {
        // swiftlint:disable force_cast
        let nibName = String(self.dynamicType).componentsSeparatedByString(".").last!
        return bundle.loadNib(nibName) as! T
        // swiftlint:enable force_cast
    }
    
}

public extension NSBundle {
    public func loadNib(name: String) -> AnyObject {
        return self.loadNibNamed(name, owner: self, options: nil)[0]
    }
}
