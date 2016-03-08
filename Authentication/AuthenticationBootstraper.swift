//
//  AuthenticationBootstraper.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/8/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

public class AuthenticationBootstraper<User: UserType, SessionService: SessionServiceType where SessionService.User == User> {
    
    private let _window: UIWindow
    private let _mainViewControllerFactory: () -> UIViewController
    
    public let sessionService: SessionService
    
    public var currentUser: User? {
        return sessionService.currentUser.value
    }
    
    public init(sessionService: SessionService, window: UIWindow, mainViewControllerFactory: () -> UIViewController) {
        _window = window
        _mainViewControllerFactory = mainViewControllerFactory
        self.sessionService = sessionService
    }
    
    public final func bootstrap() {
        if let _ = self.currentUser {
            _window.rootViewController = _mainViewControllerFactory()
        } else {
            _window.rootViewController = UINavigationController(rootViewController: createLogInController())
        }
    }
    
    public func createLogInViewModel() -> LogInViewModel<User, SessionService> {
        return LogInViewModel(sessionService: sessionService)
    }
    
    public func createLogInView() -> LogInViewType {
        return LogInView()
    }
    
}

private extension AuthenticationBootstraper {
    
    func createRegisterController() -> RegisterController { //TODO
        return RegisterController()
    }
    
    func createLogInErrorController() -> LogInErrorController { //TODO
        return LogInErrorController()
    }
    
    func createLogInController() -> LogInController<User, SessionService> {
        let a: LogInViewModel<User, SessionService> = createLogInViewModel()
        return LogInController<User, SessionService>(
            viewModel: a,
            registerControllerFactory: createRegisterController,
            logInView: createLogInView(),
            onUserLoggedIn: { _ in
                self._window.rootViewController = _mainViewControllerFactory()  //Pasarle el user?
            },
            logInErrorControllerFactory: createLogInErrorController
        )
    }
    
}