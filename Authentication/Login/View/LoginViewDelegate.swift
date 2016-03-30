//
//  LoginViewDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/18/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
    Delegate for any extra configuration
    to the login view when rendered.
*/
public protocol LoginViewDelegate {
    
    func configureView(loginView: LoginViewType)
    
}

public extension LoginViewDelegate {
    
    func configureView(loginView: LoginViewType) {
        
    }
    
}

public final class DefaultLoginViewDelegate: LoginViewDelegate { }

public final class DefaultLogoSetterLoginViewDelegate: LoginViewDelegate {
    
    private let _logoImage: UIImage?
    
    init(logoImage: UIImage?) {
        _logoImage = logoImage
    }
    
    public func configureView(loginView: LoginViewType) {
        if let logo = _logoImage {
            loginView.logoImageView.image = logo
        }
    }
    
}
