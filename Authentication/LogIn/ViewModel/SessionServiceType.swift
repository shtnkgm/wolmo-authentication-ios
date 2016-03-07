//
//  SessionServiceType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa


public protocol SessionServiceType {
    
    typealias User: UserType
    
    var currentUser: AnyProperty<User?> { get }
    
    func login(email: Email, _ password: String) -> SignalProducer<User, NSError>
    
}

