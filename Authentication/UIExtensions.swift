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

internal protocol NibViewLoader {
    
    typealias NibLoadableViewType

    static func loadFromNib() -> NibLoadableViewType
    
}

extension NibViewLoader where NibLoadableViewType: UIView {
    
    static func loadFromNib() -> NibLoadableViewType {
        // swiftlint:disable force_cast
        let bundle = NSBundle(forClass: NibLoadableViewType.self)
        let nibName = String(self).componentsSeparatedByString(".").first!
        return bundle.loadNib(nibName) as! NibLoadableViewType
        // swiftlint:enable force_cast
    }
    
}

public extension NSBundle {
    public func loadNib(name: String) -> AnyObject {
        return self.loadNibNamed(name, owner: self, options: nil)[0]
    }
}
