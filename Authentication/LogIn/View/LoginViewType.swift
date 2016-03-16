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
    
    var passwordTextFieldValid: Bool { get set }
    var emailTextFieldValid: Bool { get set }
    
}

public extension LoginViewType where Self: UIView {
    
    var view: UIView {
        return self
    }
    
}

public final class LoginView: UIView, LoginViewType {
    
    public var emailLabel: UILabel { return emailLabelOutlet }
    @IBOutlet weak var emailLabelOutlet: UILabel!
    
    public var emailTextField: UITextField { return emailTextFieldOutlet }
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    
    public var emailValidationMessageLabel: UILabel? { return emailValidationMessageLabelOutlet }
    @IBOutlet weak var emailValidationMessageLabelOutlet: UILabel!
    
    public var passwordLabel: UILabel { return passwordLabelOutlet }
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    
    public var passwordTextField: UITextField { return passwordTextFieldOutlet }
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    
    public var passwordValidationMessageLabel: UILabel? { return passwordValidationMessageLabelOutlet }
    @IBOutlet weak var passwordValidationMessageLabelOutlet: UILabel!
    
    public var passwordVisibilityButton: UIButton? { return passwordVisibilityButtonOutlet }
    @IBOutlet weak var passwordVisibilityButtonOutlet: UIButton!
    
    public var logInButton: UIButton { return logInButtonOutlet }
    @IBOutlet weak var logInButtonOutlet: UIButton!
    
    public var logInErrorLabel: UILabel? { return logInErrorLabelOutlet }
    @IBOutlet weak var logInErrorLabelOutlet: UILabel!
    
    public var registerButton: UIButton { return registerButtonOutlet }
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    public var termsAndService: UIButton? { return termsAndServiceOutlet }
    @IBOutlet weak var termsAndServiceOutlet: UIButton!
    
    
    public let activityIndicator: UIActivityIndicatorView
    
    public var passwordTextFieldValid: Bool {
        didSet {
            let color: CGColor
            if passwordTextFieldValid {
                color = UIColor.clearColor().CGColor
            } else {
                color = UIColor.redColor().CGColor
            }
            passwordTextField.layer.borderColor = color
        }
    }
    
    public var emailTextFieldValid: Bool {
        didSet {
            let color: CGColor
            if emailTextFieldValid {
                color = UIColor.clearColor().CGColor
            } else {
                color = UIColor.redColor().CGColor
            }
            emailTextField.layer.borderColor = color
        }
    }
    
    init() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        
        emailTextFieldValid = true
        passwordTextFieldValid = true
        
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
