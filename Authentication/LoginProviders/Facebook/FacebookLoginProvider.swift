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
    will contain is its corresponding AccessToken, which is the only thing
    needed for making any additional request you want.
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
    Facebook Error that may arise when trying to login
    with FacebookLoginProvider.
 
    It wraps the Error Facebook returns from the request.
 */
public struct FacebookLoginProviderError: LoginProviderError {
    
    let facebookError: Error
    
    public var localizedMessage: String {
        return facebookError.localizedDescription
    }
    
}

/**
    LoginProvider for Facebook Login.
 
    - note: If you are using this provider, you should register your application
            in https://developers.facebook.com/ and add to the Info.plist the following keys:
            `FacebookAppID`: with the app id taken from Fcebook developers page,
            `FacebookDisplayName`: with the display name by which you want the user
                to see your app with when asked for permissions.
 */
public final class FacebookLoginProvider: LoginProvider, LoginButtonDelegate {

    public static let name = "Facebook"

    public var configuration: FacebookLoginConfiguration = FacebookLoginConfiguration()
    public let userSignal: Signal<LoginProviderUserType, NoError>
    public let errorSignal: Signal<LoginProviderErrorType, NoError>
    
    fileprivate let userObserver: Observer<LoginProviderUserType, NoError>
    fileprivate let errorObserver: Observer<LoginProviderErrorType, NoError>
    
    public init() {
        (userSignal, userObserver) = Signal.pipe()
        (errorSignal, errorObserver) = Signal.pipe()
    }
    
    deinit {
        userObserver.sendCompleted()
        errorObserver.sendCompleted()
    }
    
    // Facebook Swift SDK gives as a button with fixed height at 28,
    //  so if constraint to another height, it might collide and can't
    //  assure what will happen, if enlarge or remain at 28.
    public func createButton() -> UIView {
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
    
    public func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .cancelled:
            NSLog("User cancelled Facebook login")
        case .failed(let error):
            let facebookError = FacebookLoginProviderError(facebookError: error)
            errorObserver.send(value: .facebook(error: facebookError))
        case .success(_, _, _):
            createFacebookUser(token: AccessToken.current!)
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: LoginButton) {}
    
}

fileprivate extension FacebookLoginProvider {
    
    fileprivate func createFacebookUser(token: AccessToken) {
        let fbRequest = FacebookProfileRequest()
        let connection = GraphRequestConnection()
        connection.add(fbRequest) { [unowned self] response, result in
            switch result {
            case .success(let response):
                let user = FacebookLoginProviderUser(email: response.email,
                                                     name: response.name,
                                                     userId: response.userId,
                                                     accessToken: token)
                self.userObserver.send(value: LoginProviderUserType.facebook(user: user))
            case .failed(let error):
                NSLog("Graph Request Failed: \(error) \nIf you need this info you should request it again.")
                let user = FacebookLoginProviderUser(email: .none,
                                                     name: .none,
                                                     userId: .none,
                                                     accessToken: token)
                self.userObserver.send(value: LoginProviderUserType.facebook(user: user))
            }
        }
        connection.start()
    }
    
}
