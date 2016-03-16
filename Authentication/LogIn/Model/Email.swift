//
//  Email.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


public struct Email {
    
    public static func isValidEmail(raw: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(raw)
    }
    
    let raw: String
    
    init?(raw: String) {
        guard Email.isValidEmail(raw) else {
            return nil
        }
        self.raw = raw
    }
    
}

public func == (left: Email, right: Email) -> Bool {
    return left.raw == right.raw
}
