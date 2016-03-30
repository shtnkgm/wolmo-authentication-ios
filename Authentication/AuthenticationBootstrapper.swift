//
//  AuthenticationBootstrapper.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/8/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation

/**
    Bootstrapper to start the application.
    Takes care of starting the authentication process before the main View Controller of the app when necessary,
    and after the user logs out.
    The authentication process includes login, signup and recover password logic.
*/
public class AuthenticationBootstrapper<User: UserType, SessionService: SessionServiceType where SessionService.User == User> {

    /// The window of the app
    private let _window: UIWindow
    /// The factory method from which to obtain a main View Controller for the app
    private let _mainViewControllerFactory: () -> UIViewController

    /// The entry and exit point to the user's session.
    public let sessionService: SessionService

    /// The user in session.
    public var currentUser: User? {
        return sessionService.currentUser.value
    }
    
    /// The logo image to show in login.
    public var logoImage: UIImage?

    /**
        Initializes a new authentication bootstrapper with the session service to use for logging in and out and
        the factory method from where to obtain the main View Controller of the application.

        - Parameters:
            - sessionService: The session service to use for logging in and out.
            - window: The window the application will use.
            - mainViewControllerFactory: Method that returns a valid mainViewController to use when starting the 
            core of the app

        - Returns: A new authentication bootstrapper ready to use for starting your app as needed.
    */
// swiftlint:disable valid_docs
    public init(sessionService: SessionService, window: UIWindow, mainViewControllerFactory: () -> UIViewController) {
// swiftlint:enable valid_docs
        _window = window
        _mainViewControllerFactory = mainViewControllerFactory
        self.sessionService = sessionService

        sessionService.events.observeNext { [unowned self] event in
            switch event {
            case .LogIn(_): self._window.rootViewController = self._mainViewControllerFactory()
            case .LogOut(_): self._window.rootViewController = UINavigationController(rootViewController: self.createLoginController())
            default: break
            }
        }
    }

    /**
        Bootstraps your project with the authentication framework,
        starting with the authentication project if no user is already logged in the session service.
        Otherwise, it runs your project directly from starting the main View Controller.
    */
    public final func bootstrap() {
        if let _ = self.currentUser {
            _window.rootViewController = _mainViewControllerFactory()
        } else {
            _window.rootViewController = UINavigationController(rootViewController: createLoginController())
        }
    }

    /**
        Creates the log in credential validator that embodies what must be met
        so as to enable the log in for the user.

        - Returns: A log in credentials validator to use for creating the LogInViewModel.

        - Attention: Override this method for customizing the criteria of email and password validity.
    */
    public func createLogInCredentialsValidator() -> LoginCredentialsValidator {
        return LoginCredentialsValidator()
    }

    /**
         Creates the LogInViewModel to use in the authentication process logic,
         with the LogInCredentialsValidator returned in the function createLogInCredentialsValidator.

         - Returns: A login view model that controls the log in logic and comunicates with the session service.

         - Warning: The LogInViewModel returned must be constructed with the same session service as the
         authentication bootstrapper.
     */
    public func createLoginViewModel() -> LoginViewModel<User, SessionService> {
        return LoginViewModel(sessionService: sessionService, credentialsValidator: createLogInCredentialsValidator())
    }

    /**
        Creates login view that conforms to the logInViewType protocol
        and will be use for the login visual.

        - Returns: A valid login view ready to be used.
     
        - Attention: Override this method for customizing the view for the login.
    */
    public func createLoginView() -> LoginViewType {
        let view: LoginView = LoginView.loadFromNib()
        view.delegate = DefaultLogoSetterLoginViewDelegate(logoImage: logoImage)
        return view
    }

    /**
        Creates the login view controller delegate that the login controller
        will use to add behaviour to certain events.
     
        - Returns: A valid login controller delegate to use.
     
        - Attention: Override this method for customizing any of the 
        delegate's reactions to events.
    */
    public func createLoginControllerDelegate() -> LoginControllerDelegate {
        return DefaultLoginControllerDelegate()
    }
    
    
    /**
         Creates the register (sign up) controller to use when the
         user selects that option.
         
         - Returns: A valid register controller to use.
         
         - Attention: Override this method for customizing the
         register controller to be used.
    */
    public func createRegisterController() -> RegisterController { //todo
        return RegisterController(viewModel: RegisterViewModel(), registerViewFactory: { return RegisterView()})
    }
    
    /**
         Creates the recover password main controller to use when the
         user selects that option.
         
         - Returns: A valid recover password controller to use.
         
         - Attention: Override this method for customizing the
         recover password main controller to be used.
     */
    public func createRecoverPasswordController() -> RecoverPasswordController { //todo
        return RecoverPasswordController()
    }

    public func createLoginControllerConfiguration() -> LoginControllerConfiguration {
        return LoginControllerConfiguration(
            viewModel: createLoginViewModel(),
            viewFactory: createLoginView,
            transitionDelegate: self)
    }
    
    public func createLoginController() -> LoginController {
        let configuration = createLoginControllerConfiguration()
        return LoginController(configuration: configuration)
    }
    
}

extension AuthenticationBootstrapper: LoginControllerTransitionDelegate {
    
    public func loginControllerDidTapOnRegister(controller: LoginController) {
        let registerController = createRegisterController()
        if let navigationController = controller.navigationController {
            navigationController.pushViewController(registerController, animated: true)
        } else {
            _window.rootViewController = UINavigationController(rootViewController: registerController)
        }
    }
    
    public func loginControllerDidTapOnRecoverPassword(controller: LoginController) {
        let recoverPasswordController = createRecoverPasswordController()
        if let navigationController = controller.navigationController {
            navigationController.pushViewController(recoverPasswordController, animated: true)
        } else {
            _window.rootViewController = UINavigationController(rootViewController: recoverPasswordController)
        }
    }
    
}
