//
//  LoginViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol Renderable {
    
    func render()
    
}

public protocol LoginViewType: Renderable {
    
    var view: UIView { get }
    
    var emailLabel: UILabel { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var logInButton: UIButton { get }
    var logInErrorLabel: UILabel? { get }
    var registerButton: UIButton { get }
    var termsAndService: UIButton? { get }
    
    var activityIndicator: UIActivityIndicatorView { get }
    
}

public extension LoginViewType where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

public final class LoginView: UIView, LoginViewType {
    
    public let emailLabel: UILabel
    public let emailTextField: UITextField
    public let emailValidationMessageLabel: UILabel?
    
    public let passwordLabel: UILabel
    public let passwordTextField: UITextField
    public let passwordValidationMessageLabel: UILabel?
    public let passwordVisibilityButton: UIButton?
    
    public let logInButton: UIButton
    public let logInErrorLabel: UILabel?
    public let registerButton: UIButton
    public let termsAndService: UIButton?
    
    public let activityIndicator: UIActivityIndicatorView
    
    init() {
        emailLabel = UILabel()
        emailTextField = UITextField()
        emailValidationMessageLabel = UILabel()
        
        passwordLabel = UILabel()
        passwordTextField = UITextField()
        passwordValidationMessageLabel = UILabel()
        passwordVisibilityButton = UIButton()
        
        logInButton = UIButton()
        logInErrorLabel = UILabel()
        registerButton = UIButton()
        termsAndService = UIButton()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.addSubview(activityIndicator)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render() {
        // TODO this function should configure each view elements and
        // in case we are doing the layout programatically it should
        // layout all its components
    }
    
}
