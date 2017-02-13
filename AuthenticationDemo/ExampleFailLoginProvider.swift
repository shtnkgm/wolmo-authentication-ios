//
//  ExampleFailLoginProvider.swift
//  Authentication
//
//  Created by Daniela Riesgo on 2/13/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation
import Authentication
import ReactiveSwift
import enum Result.NoError

class ExampleFailLoginProvider: LoginProvider {
    
    static var name: String { return "Failable Provider" }
    lazy var button: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.reactive.stateChanged.observeValues { [unowned self] _ in
            let loginProviderError = SimpleLoginProviderError(localizedMessage: "There was an error !")
            self.errorObserver.send(value: .custom(name: name, error: loginProviderError) )
        }
        view.addGestureRecognizer(tapRecognizer)
        let label = UILabel()
        label.text = "FAILABLE PROVIDER"
        label.textColor = .black
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()

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
    
}
