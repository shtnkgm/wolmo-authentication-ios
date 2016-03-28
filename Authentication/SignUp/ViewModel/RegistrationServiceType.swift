//
//  RegistrationServiceType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/23/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa

public enum RegistrationServiceError: ErrorType {
    case InvalidCredentials(NSError?)
    case NetworkError(NSError)
}

public protocol RegistrationServiceType {

    typealias User: UserType
    
    func signUp(name: String, _ email: Email, _ password: String) -> SignalProducer<User, RegistrationServiceError>
    
}
