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
    case login, signup
}

/**
    Coordinator to start the application and regulate screen transitions.
    Takes care of the authentication process until the Main View Controller
    of your app is shown. (The authentication process is only triggered
    when necessary).
    The authentication process includes login and signup logic.
*/
public class AuthenticationCoordinator<User, SessionService: SessionServiceType> where SessionService.User == User {
    
    /// The entry and exit point to the user's session.
    open let sessionService: SessionService
    /// The user in session.
    open var currentUser: User? { return sessionService.currentUser.value }
    
    /// The window of the app
    fileprivate let _window: UIWindow
    /// Property indicating the authentication screen to be shown the first time.
    fileprivate let _initialScreen: AuthenticationInitialScreen
    /// The factory class to create all authentication components in the process.
    fileprivate let _componentsFactory: AuthenticationComponentsFactoryType
    
    /**
        Initializes a new authentication coordinator with the session service to use for logging in and out and
        the factory method from where to obtain the main View Controller of the application.

        - Parameters:
            - sessionService: The session service to use for logging in and out.
            - window: The window the application will use.
            - initialScreen: authentication screen to be shown the first time.
                By default, Login.
            - componentsFactory: The authentication components factory used
                for creating all components necessary in the authentication logic.
    */
    public init(sessionService: SessionService, window: UIWindow,
                initialScreen: AuthenticationInitialScreen = .login,
                componentsFactory: AuthenticationComponentsFactoryType) {
        _window = window
        _initialScreen = initialScreen
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
            let mainAuthenticationController = _initialScreen == .login ? createLoginController() : createSignupController()
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
        let loginViewDelegate = _componentsFactory.createLoginViewDelegate(withConfiguration: loginViewConfiguration)
        return LoginControllerConfiguration(
            viewModelFactory: _componentsFactory.createLoginViewModelFactory(withSessionService: sessionService,
                                                                             credentialsValidator: _componentsFactory.createLogInCredentialsValidator()),
            viewFactory: _componentsFactory.createLoginViewFactory(withDelegate: loginViewDelegate),
            transitionDelegate: _componentsFactory.createLoginControllerTransitionDelegate() ?? self,
            delegate: _componentsFactory.createLoginControllerDelegate(),
            loginProviders: _componentsFactory.createLoginProviders())
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
        let signupViewDelegate = _componentsFactory.createSignupViewDelegate(withConfiguration: signupViewConfiguration)
        return SignupControllerConfiguration(
            viewModelFactory: _componentsFactory.createSignupViewModelFactory(withSessionService: sessionService,
                credentialsValidator: _componentsFactory.createSignUpCredentialsValidator(),
                configuration: signupViewConfiguration),
            viewFactory: _componentsFactory.createSignupViewFactory(withDelegate: signupViewDelegate),
            transitionDelegate: _componentsFactory.createSignupControllerTransitionDelegate() ?? self,
            delegate: _componentsFactory.createSignupControllerDelegate(),
            termsAndServicesURL: signupViewConfiguration.termsAndServicesURL,
            loginProviders: _componentsFactory.createLoginProviders())
    }
    
    /**
         Creates the terms and services controller
         to use when the user selects that option.
         
         - Returns: A valid terms and services controller.
     */
    internal func createTermsAndServicesController(with url: URL) -> TermsAndServicesController {
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
    internal func createRecoverPasswordController() -> RecoverPasswordController {
        //(todo)
        return RecoverPasswordController()
    }
    
}

extension AuthenticationCoordinator: LoginControllerTransitionDelegate {
    
    public final func onLoginSuccess(from controller: LoginController) {
        _window.rootViewController = _componentsFactory.createMainViewController()
    }
    
    public final func toSignup(from controller: LoginController) {
        if _initialScreen == .login {
            let signupController = createSignupController()
            controller.navigationController!.pushViewController(signupController, animated: true)
        } else {
            controller.navigationController!.popViewController(animated: true)
        }
    }
    
    public final func toRecoverPassword(from controller: LoginController) {
        let recoverPasswordController = createRecoverPasswordController()
        controller.navigationController!.pushViewController(recoverPasswordController, animated: true)
    }
    
}

extension AuthenticationCoordinator: SignupControllerTransitionDelegate {
    
    public final func onSignupSuccess(from controller: SignupController) {
        _window.rootViewController = _componentsFactory.createMainViewController()
    }
    
    public final func toLogin(from controller: SignupController) {
        if _initialScreen == .signup {
            let loginController = createLoginController()
            controller.navigationController!.pushViewController(loginController, animated: true)
        } else {
            controller.navigationController!.popViewController(animated: true)
        }
    }
    
    public final func onTermsAndServices(from controller: SignupController) {
        let configuration = _componentsFactory.createSignupViewConfiguration()
        let termsAndServicesController = createTermsAndServicesController(with: configuration.termsAndServicesURL)
        controller.navigationController!.pushViewController(termsAndServicesController, animated: true)
    }
    
}
