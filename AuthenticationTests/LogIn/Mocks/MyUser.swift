//
//  MyUser.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/14/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import Authentication

struct MyUser: UserType {
    let email: Email
    let name: String
    let password: String
    
    init(email: Email, password: String, name: String) {
        self.email = email
        self.name = name
        self.password = password
    }
}