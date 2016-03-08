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
    
    var emailLabel: UILabel { get }
    var emailTextField: UITextField { get }
    var emailValidationMessageLabel: UILabel? { get }
    
    var passwordLabel: UILabel { get }
    var passwordTextField: UITextField { get }
    var passwordValidationMessageLabel: UILabel? { get }
    var passwordVisibilityButton: UIButton? { get }
    
    var loginButton: UIButton { get }
    var registerButton: UIButton { get }
    var termsAndService: UIButton? { get }
    
    var activityIndicator: UIActivityIndicatorView { get }
    
}

final class LogInView: UIView, LogInViewType {  //TODO preguntar UIView en protocolo
    
    //TODO return real objects
    var emailLabel: UILabel { return UILabel() }
    var emailTextField: UITextField { return UITextField() }
    var emailValidationMessageLabel: UILabel? { return .None }
    
    var passwordLabel: UILabel { return UILabel() }
    var passwordTextField: UITextField { return UITextField() }
    var passwordValidationMessageLabel: UILabel? { return .None }
    var passwordVisibilityButton: UIButton? { return .None }
    
    var loginButton: UIButton { return UIButton() }
    var registerButton: UIButton { return UIButton() }
    var termsAndService: UIButton? { return .None }
    
    var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        return activityIndicator
    }
    
    func render() {
        // TODO this function should configure each view elements and
        // in case we are doing the layout programatically it should
        // layout all its components
    }
    
}