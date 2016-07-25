//
//  AuthenticationBootstrapper.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/8/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Core

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
    
    /// The configuration that defines colour and fonts and assets, like the logo, used in the views.
    /// It also includes other configurations like the textfields selected to use in signup.
    private let _viewConfiguration: AuthenticationViewConfiguration
    
    /// The entry and exit point to the user's session.
    public let sessionService: SessionService

    /// The user in session.
    public var currentUser: User? {
        return sessionService.currentUser.value
    }


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
    public init(sessionService: SessionService, window: UIWindow,
        viewConfiguration: AuthenticationViewConfiguration = AuthenticationViewConfiguration(),
        mainViewControllerFactory: () -> UIViewController) {
        _window = window
        _mainViewControllerFactory = mainViewControllerFactory
        _viewConfiguration = viewConfiguration
        self.sessionService = sessionService

        sessionService.events.observeNext { [unowned self] event in
            switch event {
            case .LogIn(_): self._window.rootViewController = self._mainViewControllerFactory()
            case .SignUp(_): self._window.rootViewController = self._mainViewControllerFactory()
            case .LogOut(_): self._window.rootViewController = UINavigationController(rootViewController: self.createLoginController())
            default: break
            }
        }
    }

    /**
        Bootstraps your project with the authentication framework,
        starting with the authentication project if no user is already logged in the session service.
        Otherwise, it runs your project directly from starting the Main View Controller.
    */
    public final func bootstrap() {
        if let _ = self.currentUser {
            _window.rootViewController = _mainViewControllerFactory()
        } else {
            _window.rootViewController = UINavigationController(rootViewController: createLoginController())
        }
    }
}

// MARK: - Login Functions
public extension AuthenticationBootstrapper {
    
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
        Creates the log in credential validator that embodies what must be met
        so as to enable the log in for the user.

        - Returns: A log in credentials validator to use for creating the LogInViewModel.

        - Attention: Override this method for customizing the criteria of email and password validity.
        You can use email as username if you use the correct validator for it.
    */
    public func createLogInCredentialsValidator() -> LoginCredentialsValidator {
        return LoginCredentialsValidator()
    }

    /**
         Creates the LoginViewModelType to use in the authentication process logic,
         with the LogInCredentialsValidator returned in the function createLogInCredentialsValidator.

         - Returns: A login view model that controls the login logic and communicates with the session service.

         - Attention: Override this method for using your own login logic, your own login view model.
     
         - Warning: The LoginViewModel returned must be constructed with the same session service as the
         authentication bootstrapper, if it needs a session service, like the default one.
     */
    public func createLoginViewModel() -> LoginViewModelType {
        return LoginViewModel(sessionService: sessionService, credentialsValidator: createLogInCredentialsValidator())
    }

    /**
        Creates login view that conforms to the logInViewType protocol
        and will be use for the login visual.

        - Returns: A valid login view ready to be used.
     
        - Attention: Override this method for customizing the view for the login,
        other than the provided by LoginViewDelegate and LoginViewConfigurationType.
    */
    public func createLoginView() -> LoginViewType {
        let view = LoginView.loadFromNib(FrameworkBundle)!
        view.delegate = createLoginViewDelegate()
        return view
    }
    
    /**
         Creates the LoginViewDelegate to use in configuring the login view style.
         
         - Returns: A login view delegate that controls the color and font palette
         setting of the view.
         
         - Attention: Override this method for using you own LoginViewDelegate,
         when configuring the default one with the AuthenticationViewConfiguration
         passed to the AuthenticationBootstrapper is not enough, or the binding
         logic of view elements and palette hierarchy must be changed.
     
         - Warning: The LoginViewDelegate returned must consider the LoginViewConfigurationType
         the AuthenticationBootstrapper holds in its view configuration.
     */
    public func createLoginViewDelegate() -> LoginViewDelegate {
        return DefaultLoginViewDelegate(configuration: _viewConfiguration.loginConfiguration)
    }

    /**
        Creates the login view controller delegate that the login controller
        will use to add behaviour to certain events, described in
        LoginControllerDelegate protocol.
     
        - Returns: A valid login controller delegate to use.
     
        - Attention: Override this method for customizing any of the used
        delegate's reactions to events.
    */
    public func createLoginControllerDelegate() -> LoginControllerDelegate {
        return DefaultLoginControllerDelegate()
    }
    
    /**
         Creates the login view controller configuration that the login controller
         will use to access the login view model to use,
         the login view to display and the transition delegate
         to use for transitions to other screens.
         
         - Returns: A valid login controller configuration to use.
         
         - Attention: Override this method for customizing any of the used
         configuration's parameters.
     */
    public func createLoginControllerConfiguration() -> LoginControllerConfiguration {
        return LoginControllerConfiguration(
            viewModel: createLoginViewModel(),
            viewFactory: createLoginView,
            transitionDelegate: createLoginControllerTransitionDelegate())
    }
    
    /**
         Creates the login controller transition delegate that
         the login controller will use to handle transitions
         to other screens (like signup).
         
         - Returns: A valid login controller transition delegate to use.
         
         - Attention: Override this method for customizing any of the transitions
         in a way where overriding the transition's delegate methods of the
         AuthenticationBootstrapper isn't enough.
     */
    public func createLoginControllerTransitionDelegate() -> LoginControllerTransitionDelegate {
        return self
    }

}

// MARK: - Signup Functions
public extension AuthenticationBootstrapper {
    
    /**
         Creates the signup controller to use when the
         user selects that option.
         
         - Returns: A valid signup controller to use.
    */
    internal func createSignupController() -> SignupController {
        return SignupController(configuration: createSignupControllerConfiguration())
    }
    
    /**
         Creates the SignupViewModel to use in the registration process logic,
         with the SignUpCredentialsValidator returned in the function createSignUpCredentialsValidator,
         and the configuration given to the AuthenticationBootstrapper in its AuthenticationViewConfiguration.
         
         - Returns: A signup view model that controls the registration logic and comunicates with the session service.
         
         - Warning: The SignupViewModel returned must be constructed with the same session service as the
         authentication bootstrapper.
     */
    public func createSignupViewModel() -> SignupViewModelType {
        return SignupViewModel(sessionService: sessionService,
                               credentialsValidator: createSignUpCredentialsValidator(),
                               passwordConfirmationEnabled: _viewConfiguration.signupConfiguration.passwordConfirmationEnabled,
                               usernameEnabled: _viewConfiguration.signupConfiguration.usernameEnabled)
    }
    
    /**
         Creates the sign up credential validator that embodies the criteria that must be met
         so as to enable the sign up for the user.
         
         - Returns: A sign up credentials validator to use for creating the SignupViewModel.
         
         - Attention: Override this method for customizing the criteria of username, email
         and password validity.
         You can set in SignupConfiguration which textfields to use during signup so if you
         won't use one of them, you don't have to worry about its validator.
     */
    public func createSignUpCredentialsValidator() -> SignupCredentialsValidator {
        return SignupCredentialsValidator()
    }
    
    /**
         Creates the SignupViewDelegate to use in configuring the signup view style.
         
         - Returns: A signup view delegate that controls the color and font palette
        setting of the view.
     
         - Attention: Override this method for using you own SignupViewDelegate,
         when configuring the default one with the AuthenticationViewConfiguration
         passed to the AuthenticationBootstrapper is not enough, or the binding
         logic of view elements and palette hierarchy must be changed.
         
         - Warning: The SignupViewDelegate returned must consider the SignupViewConfigurationType
         the AuthenticationBootstrapper holds in its view configuration.
     */
    public func createSignupViewDelegate() -> SignupViewDelegate {
        return DefaultSignupViewDelegate(configuration: _viewConfiguration.signupConfiguration)
    }
    
    /**
         Creates the signup view controller delegate
         that the signup controller will use to add behaviour
         to certain events, described in SignupControllerDelegate
         protocol.
         
         - Returns: A valid signup controller delegate to use.
         
         - Attention: Override this method for customizing any of the used
         delegate's reactions to events.
     */
    public func createSignupControllerDelegate() -> SignupControllerDelegate {
        return DefaultSignupControllerDelegate()
    }
    
    /**
         Creates signup view that conforms to the SignupViewType protocol
         and will be use for the signup visual.
         
         - Returns: A valid signup view ready to be used.
         
         - Attention: Override this method for customizing the view for the signup.
     */
    public func createSignupView() -> SignupViewType {
        let view = SignupView.loadFromNib(FrameworkBundle)!
        view.delegate = createSignupViewDelegate()
        return view
    }
    
    /**
         Creates the signup view controller configuration that the signup controller
         will use to access the signup view model to use,
         the signup view to display and the transition delegate
         to use for transitions to other screens.
         
         - Returns: A valid signup controller configuration to use.
         
         - Attention: Override this method for customizing any of the used
         configuration's parameters.
     */
    public func createSignupControllerConfiguration() -> SignupControllerConfiguration {
        return SignupControllerConfiguration(
            viewModel: createSignupViewModel(),
            viewFactory: createSignupView,
            transitionDelegate: createSignupControllerTransitionDelegate())
    }
    
    /**
         Creates the signup controller transition delegate that
         the signup controller will use to handle transitions
         to other screens (like login or terms and services).
         
         - Returns: A valid login controller transition delegate to use.
         
         - Attention: Override this method for customizing any of the transitions
         in a way where overriding the transition's delegate methods of the
         AuthenticationBootstrapper isn't enough.
     */
    public func createSignupControllerTransitionDelegate() -> SignupControllerTransitionDelegate {
        return self
    }
    
}

// MARK: - RecoverPassword Functions
public extension AuthenticationBootstrapper {
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



extension AuthenticationBootstrapper: LoginControllerTransitionDelegate {
    
    /**
         Function that reacts to the user pressing "Sign Up" in the
         login screen.
         It will push the new controller in the navigation controller.
     */
    public final func onSignup(controller: LoginController) {
        let signupController = createSignupController()
        // The authentication framework starts the process with a navigation controller.
        controller.navigationController!.pushViewController(signupController, animated: true)
    }
    
    /**
         Function that reacts to the user pressing "Recover Password"
         in the login screen.
         It will push the new controller in the navigation controller.
     */
    public final func onRecoverPassword(controller: LoginController) {
        let recoverPasswordController = createRecoverPasswordController()
        // The authentication framework starts the process with a navigation controller.
        controller.navigationController!.pushViewController(recoverPasswordController, animated: true)
    }
    
}

extension AuthenticationBootstrapper: SignupControllerTransitionDelegate {
    
    /**
         Function that reacts to the user pressing "Log In"
         in the signup screen.
         It will pop the signup controller from the navigation controller,
         to return to login screen.
     */
    public final func onLogin(controller: SignupController) {
        // The authentication framework starts the process with a navigation controller.
        controller.navigationController!.popViewControllerAnimated(true)
    }
    
}
