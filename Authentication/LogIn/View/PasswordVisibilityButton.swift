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
            switch $0 {
            case .ShowPassword: self.setTitle("Hide", forState: .Normal)
            case .HidePassword: self.setTitle("Show", forState: .Normal)
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}