//
//  FacebookLoginProvider.swift
//  Authentication
//
//  Created by Gustavo Cairo on 1/13/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import FacebookLogin
import FacebookCore
import enum Result.NoError

/**
    Simple struct to encapsulate a Facebook profile request.
 */
internal struct FacebookProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var email: String?
        var name: String?
        var userId: Int64?
        
        init(rawResponse: Any?) {
            print(rawResponse!)
            if let dict = rawResponse as? [String: Any] {
                email = (dict["email"] as? String)!
                name = (dict["name"] as? String)!
                userId = Int64((dict["id"] as? String)!)
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "name, id, email"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

/**
    User returned after logging in with Facebook.
 
    Except for the access token, all other properties are optional
    because they are requested in a separate request after the login
    is completed. If this extra request fails, the only information the user
    will contain is its corresponding AccessToken.
 */
public struct FacebookLoginProviderUser: LoginProviderUser {
    public let email: Email?
    public let name: String?
    public let userId: Int64?
    public let accessToken: AccessToken
    
    init(email: String?, name: String?, userId: Int64?, accessToken: AccessToken) {
        if let unwrappedEmail = email {
            self.email = Email(raw: unwrappedEmail)
        } else {
            self.email = .none
        }
        self.name = name
        self.userId = userId
        self.accessToken = accessToken
    }
}

/**
    LoginProvider for Facebook Login.
 */
public final class FacebookLoginProvider: LoginProvider, LoginButtonDelegate {
    
    public var configuration: FacebookLoginConfiguration = FacebookLoginConfiguration()
    public let userSignal: Signal<LoginProviderUserType, NoError>
    public lazy var button: UIView = self.createButton()
    private let observer: Observer<LoginProviderUserType, NoError>
    
    public init() {
        (userSignal, observer) = Signal.pipe()
    }
    
    deinit {
        observer.sendCompleted()
    }
    
    public func configure() {}
    
    public func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .cancelled:
            print("User cancelled Facebook login")
        case .failed(let error):
            print(error)
        case .success(_, _, _):
            createFacebookUser()
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: LoginButton) {}

    private func createButton() -> UIView {
        let button: LoginButton
        if configuration.publishPermissions.isEmpty {
            button = LoginButton(readPermissions: configuration.readPermissions)
        } else {
            button = LoginButton(publishPermissions: configuration.publishPermissions)
        }
        button.defaultAudience = configuration.defaultAudience
        button.delegate = self
        return button
    }
    
    private func createFacebookUser() {
        let fbRequest = FacebookProfileRequest()
        let connection = GraphRequestConnection()
        connection.add(fbRequest) { [unowned self] response, result in
            switch result {
            case .success(let response):
                let user = FacebookLoginProviderUser(email: response.email,
                                                     name: response.name,
                                                     userId: response.userId,
                                                     accessToken: AccessToken.current!)
                self.observer.send(value: LoginProviderUserType.facebook(user: user))
            case .failed(let error):
                //NSLog("facebook-login-error.failed-extra-info-request.log-message".frameworkLocalized)
                print("Graph Request Failed: \(error) \nIf you need this info you should request it again.")
                let user = FacebookLoginProviderUser(email: .none,
                                                     name: .none,
                                                     userId: .none,
                                                     accessToken: AccessToken.current!)
                self.observer.send(value: LoginProviderUserType.facebook(user: user))
            }
        }
        connection.start()
    }
    
}
