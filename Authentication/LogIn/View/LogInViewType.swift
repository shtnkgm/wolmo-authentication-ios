//
//  LogInViewType.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public protocol Renderable {
    
    func render()
    
}

public protocol LogInViewType: Renderable {
    
    var view: UIView { get }
    
    var emailLabel: UILabel { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var loginButton: UIButton { get }
    var loginErrorLabel: UILabel? { get }
    var registerButton: UIButton { get }
    var termsAndService: UIButton? { get }
    
    var activityIndicator: UIActivityIndicatorView { get }
    
}

public extension LogInViewType where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

public final class LogInView: UIView, LogInViewType {
    
    //TODO return real objects
    public var emailLabel: UILabel { return UILabel() }
    public var emailTextField: UITextField { return UITextField() }
    public var emailValidationMessageLabel: UILabel? { return .None }
    
    public var passwordLabel: UILabel { return UILabel() }
    public var passwordTextField: UITextField { return UITextField() }
    public var passwordValidationMessageLabel: UILabel? { return .None }
    public var passwordVisibilityButton: UIButton? { return .None }
    
    public var loginButton: UIButton { return UIButton() }
    public var loginErrorLabel: UILabel? { return .None }
    public var registerButton: UIButton { return UIButton() }
    public var termsAndService: UIButton? { return .None }
    
    public var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        return activityIndicator
    }
    
    public func render() {
        // TODO this function should configure each view elements and
        // in case we are doing the layout programatically it should
        // layout all its components
    }
    
}
