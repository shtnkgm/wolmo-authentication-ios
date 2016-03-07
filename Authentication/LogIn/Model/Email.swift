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
        return true
    }
    
    let raw: String
    
    init?(raw: String) {
        guard Email.isValidEmail(raw) else {
            return nil
        }
        self.raw = raw
    }
    
}
