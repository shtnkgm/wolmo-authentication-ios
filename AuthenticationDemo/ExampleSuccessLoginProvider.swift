//
//  ExampleSuccessLoginProvider.swift
//  Authentication
//
//  Created by Daniela Riesgo on 2/13/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation
import Authentication
import ReactiveSwift
import enum Result.NoError

struct LoginProviderExampleUser: LoginProviderUser {

    let name: String

}

class ExampleSuccessLoginProvider: LoginProvider {
    
    static var name: String { return "Successful Provider" }
    
    let userSignal: Signal<LoginProviderUserType, NoError>
    let errorSignal: Signal<LoginProviderErrorType, NoError>
    
    private let userObserver: Observer<LoginProviderUserType, NoError>
    private let errorObserver: Observer<LoginProviderErrorType, NoError>
    
    init() {
        (userSignal, userObserver) = Signal.pipe()
        (errorSignal, errorObserver) = Signal.pipe()
    }
    
    deinit {
        userObserver.sendCompleted()
        errorObserver.sendCompleted()
    }
    
    func createButton() -> UIView {
        let view = UIView()
        view.backgroundColor = .green
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.reactive.stateChanged.observeValues { [unowned self] _ in
            let user = LoginProviderExampleUser(name: "My Ex. User")
            let providerUser = LoginProviderUserType.custom(name: ExampleSuccessLoginProvider.name, user: user)
            self.userObserver.send(value: providerUser)
        }
        view.addGestureRecognizer(tapRecognizer)
        let label = UILabel()
        label.text = "SUCCESSFUL PROVIDER"
        label.textColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }

    func logOut() -> SignalProducer<(), LoginProviderErrorType> {
        return SignalProducer.empty
    }

    public var currentUser: LoginProviderUserType?
    
    public func handleUrl(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return false
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
}
