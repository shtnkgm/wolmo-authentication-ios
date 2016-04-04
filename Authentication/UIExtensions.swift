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
