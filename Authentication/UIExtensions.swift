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
    
    public func setAction(events: UIControlEvents = .TouchUpInside, _ action: (Self, UIEvent) -> Void) {
        let handler = ActionHandler(action: action)
        self.addTarget(handler, action: #selector(handler.action(_:forEvent:)), forControlEvents: events)
        objc_setAssociatedObject(self, actionHandlerTypeAssociatedObjectKey, handler, .OBJC_ASSOCIATION_RETAIN)
    }
    
}

extension UIControl: ActionHandlerType {}

private let actionHandlerTypeAssociatedObjectKey = UnsafeMutablePointer<Int8>.alloc(1)

private class ActionHandler<T>: NSObject {
    private let _action: ((T, UIEvent) -> Void)
    
    init(action: (T, UIEvent) -> Void) {
        self._action = action
    }
    
    @objc func action(sender: UIControl, forEvent event: UIEvent) {
        if let sender = sender as? T {
            _action(sender, event)
        }
    }
    
}

internal protocol NibLoadable {

    static func loadFromNib() -> Self
    
}

extension NibLoadable where Self: UIView {
    
    static func loadFromNib() -> Self {
        // swiftlint:disable force_cast
        let bundle = NSBundle(forClass: Self.self)
        let nibName = String(self).componentsSeparatedByString(".").first!
        return bundle.loadNib(nibName) as! Self
        // swiftlint:enable force_cast
    }
    
}

public extension NSBundle {
    
    public func loadNib(name: String) -> AnyObject {
        return self.loadNibNamed(name, owner: self, options: nil)[0]
    }

}


extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substringFromIndex(start)
            
            if hexColor.characters.count == 8 {
                let scanner = NSScanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexLongLong(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

public extension UITextField {
    
    // This is intended to be used when we have a form, so in the delegate we can directly change to the next texfield
    // (which is assigned previously in nextTextField)
    public var nextTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &nextTextFieldKey) as? UITextField
        }
        
        set {
            objc_setAssociatedObject(self, &nextTextFieldKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var nextTextFieldKey: UInt8 = 0
