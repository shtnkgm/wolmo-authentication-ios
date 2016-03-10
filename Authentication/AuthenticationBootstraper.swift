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
        
        sessionService.events.observeNext { [unowned self] event in
            switch event {
            case .LogIn(_): self._window.rootViewController = self._mainViewControllerFactory()  //Pasarle el user?
            case .LogOut(_): self._window.rootViewController = UINavigationController(rootViewController: self.createLogInController())
            }
        }
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
    
    func transitionToSignUp() {
        let controller = createRegisterController()
        self._window.rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func createLogInErrorController(error: SessionServiceError) -> LogInErrorController { //TODO
        return LogInErrorController()
    }
    
    func transitionToLogInError(error: SessionServiceError) {
        let controller = createLogInErrorController(error)
        self._window.rootViewController?.presentViewController(controller, animated: false, completion: nil)
    }
    
    func createLogInController() -> LogInController {
        return LogInController(
            viewModel: createLogInViewModel(),
            logInView: createLogInView(),
            onLogInError: transitionToLogInError,
            onRegister: { [unowned self] _ in self.transitionToSignUp() }
        )
    }
    
}