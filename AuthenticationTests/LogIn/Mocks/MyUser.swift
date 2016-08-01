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
    let username: String
    let password: String
    
    init(email: Email, password: String, username: String) {
        self.email = email
        self.username = username
        self.password = password
    }
}