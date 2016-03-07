//
//  PasswordVisibilityButton.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class PasswordVisibilityButton: UIButton {
    
    public enum Mode {
        
        case ShowPassword
        case HidePassword
        
        init(showPassword: Bool) {
            if showPassword {
                self = .ShowPassword
            } else {
                self = .HidePassword
            }
        }
        
    }
    
    public let mode: MutableProperty<Mode>
    
    init(mode: Mode = .HidePassword, frame: CGRect = CGRectZero) {
        self.mode = MutableProperty(mode)
        super.init(frame: frame)
        
        self.mode.signal.observeNext {
            switch $0 {         // so as to show "hide" when shown, and viceversa
            case .ShowPassword: self.setTitle("password-visibility.title".localized(false), forState: .Normal)
            case .HidePassword: self.setTitle("password-visibility.title".localized(true), forState: .Normal)
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) { //TODO
        fatalError("init(coder:) has not been implemented")
    }
    
}