//
//  AuthenticationCoordinator.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/8/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Core

/*
    Enumeration representing an authentication screen
    that can be used as the starting point of
    authentication process.
 */

public enum AuthenticationInitialScreen {
    case Login, Signup
}

/**
    Coordinator to start the application and regulate screen transitions.
    Takes care of the authentication process until the Main View Controller
    of your app is shown. (The authentication process is only triggered
    when necessary).
    The authentication process includes login and signup logic.
*/
public class AuthenticationCoordinator<User, SessionService: SessionServiceType where SessionService.User == User> {
    
    /// The entry and exit point to the user's session.
    public let sessionService: SessionService
    /// The user in session.
    public var currentUser: User? { return sessionService.currentUser.value }
    
    /// The window of the app
    private let _window: UIWindow
    /// The factory class to create all authentication components in the process.
    private let _componentsFactory: AuthenticationComponentsFactoryType
    
    /**
        Initializes a new authentication bootstrapper with the session service to use for logging in and out and
        the factory method from where to obtain the main View Controller of the application.

        - Parameters:
            - sessionService: The session service to use for logging in and out.
            - window: The window the application will use.
            - componentsFactory: The authentication components factory used
                for creating all components necessary in the authentication logic.
    */
    public init(sessionService: SessionService, window: UIWindow,
                componentsFactory: AuthenticationComponentsFactoryType) {
        _window = window
        _componentsFactory = componentsFactory
        self.sessionService = sessionService
    }

    /**
        Bootstraps your project with the authentication framework,
        starting with the authentication project if no user is already logged in the session service.
        Otherwise, it runs your project directly from starting the Main View Controller.
    */
    public final func start() {
        if let _ = self.currentUser {
            _window.rootViewController = _componentsFactory.createMainViewController()
        } else {
            let mainAuthenticationController = _componentsFactory.initialScreen == .Login ? createLoginController() : createSignupController()
            _window.rootViewController = UINavigationController(rootViewController: mainAuthenticationController)
        }
    }
    
}

// MARK: - Login Functions
public extension AuthenticationCoordinator {
    
    /**
         Creates the login controller to use for starting
         the authentication process.
         
         - Returns: A valid login controller to use.
     */
    internal func createLoginController() -> LoginController {
        let configuration = createLoginControllerConfiguration()
        return LoginController(configuration: configuration)
    }

    /**
         Creates the login view controller configuration
         that the login controller will use to access the
         login view model to use, the login view to display
         and the delegates for events and transitions to
         other screens.
         
         It uses the components returned by the
         components factory.
         
         - Returns: A valid login controller configuration to use.
     */
    internal func createLoginControllerConfiguration() -> LoginControllerConfiguration {
        let loginViewConfiguration = _componentsFactory.createLoginViewConfiguration()
        let loginViewDelegate = _componentsFactory.createLoginViewDelegate(loginViewConfiguration)
        let createLoginView: () -> LoginViewType = { [unowned self] in self._componentsFactory.createLoginView(loginViewDelegate) }
        return LoginControllerConfiguration(
            viewModel: _componentsFactory.createLoginViewModel(sessionService,
                credentialsValidator: _componentsFactory.createLogInCredentialsValidator()),
            viewFactory: createLoginView,
            transitionDelegate: _componentsFactory.createLoginControllerTransitionDelegate() ?? self,
            delegate: _componentsFactory.createLoginControllerDelegate())
    }

}

// MARK: - Signup Functions
public extension AuthenticationCoordinator {

    /**
         Creates the signup controller to use when the
         user selects that option.
         
         - Returns: A valid signup controller to use.
    */
    internal func createSignupController() -> SignupController {
        return SignupController(configuration: createSignupControllerConfiguration())
    }
    
    /**
         Creates the signup view controller configuration
         that the signup controller will use to access the
         signup view model to use, the signup view to display
         and the delegates for events and transitions to
         other screens.
     
         It uses the components returned by the
         components factory.
     
         - Returns: A valid signup controller configuration to use.
     */
    internal func createSignupControllerConfiguration() -> SignupControllerConfiguration {
        let signupViewConfiguration = _componentsFactory.createSignupViewConfiguration()
        let signupViewDelegate = _componentsFactory.createSignupViewDelegate(signupViewConfiguration)
        let createSignupView: () -> SignupViewType = { [unowned self] in self._componentsFactory.createSignupView(signupViewDelegate) }
        return SignupControllerConfiguration(
            viewModel: _componentsFactory.createSignupViewModel(sessionService,
                credentialsValidator: _componentsFactory.createSignUpCredentialsValidator(),
                configuration: signupViewConfiguration),
            viewFactory: createSignupView,
            transitionDelegate: _componentsFactory.createSignupControllerTransitionDelegate() ?? self,
            delegate: _componentsFactory.createSignupControllerDelegate(),
            termsAndServicesURL: signupViewConfiguration.termsAndServicesURL)
    }
    
    /**
         Creates the terms and services controller
         to use when the user selects that option.
         
         - Returns: A valid terms and services controller.
     */
    internal func createTermsAndServicesController(url: NSURL) -> TermsAndServicesController {
        return TermsAndServicesController(url: url, delegate: _componentsFactory.createTermsAndServicesControllerDelegate())
    }
    
}

// MARK: - RecoverPassword Functions
public extension AuthenticationCoordinator {
    
    /**
         Creates the recover password main controller to use when the
         user selects that option.
         
         - Returns: A valid recover password controller to use.
     */
    public func createRecoverPasswordController() -> RecoverPasswordController {
        // TODO
        return RecoverPasswordController()
    }
    
}



extension AuthenticationCoordinator: LoginControllerTransitionDelegate {
    
    public final func onLoginSuccess(controller: LoginController) {
        _window.rootViewController = _componentsFactory.createMainViewController()
    }
    
    public final func toSignup(controller: LoginController) {
        if _componentsFactory.initialScreen == .Login {
            let signupController = createSignupController()
            controller.navigationController!.pushViewController(signupController, animated: true)
        } else {
            controller.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    public final func toRecoverPassword(controller: LoginController) {
        let recoverPasswordController = createRecoverPasswordController()
        controller.navigationController!.pushViewController(recoverPasswordController, animated: true)
    }
    
}

extension AuthenticationCoordinator: SignupControllerTransitionDelegate {
    
    public final func onSignupSuccess(controller: SignupController) {
        _window.rootViewController = _componentsFactory.createMainViewController()
    }
    
    public final func toLogin(controller: SignupController) {
        if _componentsFactory.initialScreen == .Signup {
            let loginController = createLoginController()
            controller.navigationController!.pushViewController(loginController, animated: true)
        } else {
            controller.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    public final func onTermsAndServices(controller: SignupController) {
        let configuration = _componentsFactory.createSignupViewConfiguration()
        let termsAndServicesController = createTermsAndServicesController(configuration.termsAndServicesURL)
        controller.navigationController!.pushViewController(termsAndServicesController, animated: true)
    }
    
}
