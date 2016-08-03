//
//  AuthenticationComponentsFactory.swift
//  Authentication
//
//  Created by Daniela Riesgo on 8/1/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

public protocol AuthenticationComponentsFactoryType: LoginComponentsFactory, SignupComponentsFactory {
    
    func createMainViewController() -> UIViewController
    
}

/**
    Factory that uses default implementations of the protocol
    and stores all information needed for methods without default
    implementation.
    It stores the view configurations and the main view controller
    factory method.
 */
public struct AuthenticationComponentsFactory: AuthenticationComponentsFactoryType {
    
    private let _mainControllerFactory: () -> UIViewController
    private let _loginConfiguration: LoginViewConfigurationType
    private let _signupConfiguration: SignupViewConfigurationType
    
    /**
        Initializes the AuthenticationComponentsFactory
        with the components to use.
        
        - Parameters:
            - loginConfiguration: login view configuration to
                return when asked for it.
            - signupConfiguration: signup view configuration to
                return when asked for it.
            - mainControllerFactory: main view controller factory
                method to trigger when asked for the main view
                controller.
    */
    public init(loginConfiguration: LoginViewConfigurationType,
                signupConfiguration: SignupViewConfigurationType,
                mainControllerFactory: () -> UIViewController) {
        _mainControllerFactory = mainControllerFactory
        _loginConfiguration = loginConfiguration
        _signupConfiguration = signupConfiguration
    }
    
    /**
         Initializes the AuthenticationComponentsFactory
         with the components to use.
         
         - Parameters:
             - initialScreen: authentication screen to be shown
                the first time. By default, Login.
             - logo: logo to add to the default LoginViewConfiguration.
             - termsAndServicesURL: terms and services URL used
                to create the default SignupViewConfiguration.
             - mainControllerFactory: main view controller factory
                method to trigger when asked for the main view
                controller.
     */
    public init(logo: UIImage? = .None,
                termsAndServicesURL: NSURL,
                mainControllerFactory: () -> UIViewController) {
        self.init(loginConfiguration: LoginViewConfiguration(logoImage: logo),
                  signupConfiguration: SignupViewConfiguration(termsAndServicesURL: termsAndServicesURL),
                  mainControllerFactory: mainControllerFactory)
    }
    
    public func createMainViewController() -> UIViewController {
        return _mainControllerFactory()
    }
    
    public func createLoginViewConfiguration() -> LoginViewConfigurationType {
        return _loginConfiguration
    }
    
    public func createSignupViewConfiguration() -> SignupViewConfigurationType {
        return _signupConfiguration
    }
    
}


public protocol LoginComponentsFactory {
    
    /**
         Creates the log in credential validator that embodies what must be met
         so as to enable the log in for the user.
         
         - Returns: A log in credentials validator to use for creating the LogInViewModel.
            By default, the default LoginCredentialsValidator.
     */
    func createLogInCredentialsValidator() -> LoginCredentialsValidator
    
    /**
         Creates the LoginViewModelType to use in the authentication process logic.
         
         - Parameters:
            - sessionService: the session service to use for login action.
            - credentialsValidator: the credentials validator to use for validating
                entries, before enabling the user to log in.
     
         - Returns: A login view model that controls the login logic and communicates
            with the session service.
            By default, the default LoginViewModel with the parameters received.
     */
    func createLoginViewModel<SessionService: SessionServiceType>(sessionService: SessionService, credentialsValidator: LoginCredentialsValidator) -> LoginViewModelType
    
    /**
        Creates the LoginViewConfiguration to use for setting
        the login view configuration.
     
        - Returns: A valid login view configuration to use.
     
        - Attention: There is no default implementation.
    */
    func createLoginViewConfiguration() -> LoginViewConfigurationType
    
    /**
         Creates the LoginViewDelegate to use in configuring the login view style.
     
         - Parameters:
            - configuration: view configuration that defines the palettes and logo
            image to configure the view.
         
         - Returns: A login view delegate that controls the color and font palette
             setting of the view.
             By default, the DefaultLoginViewDelegate.
     */
    func createLoginViewDelegate(configuration: LoginViewConfigurationType) -> LoginViewDelegate
    
    /**
         Creates login view that conforms to the logInViewType protocol
         and will be use for the login visual.
     
         - Parameters:
            - delegate: view delegate for configuring the login view.
         
         - Returns: A valid login view ready to be used.
            By default, the default LoginView.
     */
    func createLoginView(delegate: LoginViewDelegate) -> LoginViewType
    
    /**
         Creates the login view controller delegate that the login controller
         will use to add behaviour to certain events, described in
         LoginControllerDelegate protocol.
         
         - Returns: A valid login controller delegate to use.
            By default, the DefaultLoginControllerDelegate.
     */
    func createLoginControllerDelegate() -> LoginControllerDelegate
    
    /**
         Creates the login controller transition delegate that
         the login controller will use to handle transitions
         to other screens (like signup).
         
         - Returns: A valid login controller transition delegate to use,
            or .None if wanting to use the Coordinator's default
            implementation of the protocol.
            By default, returns .None.
     */
    func createLoginControllerTransitionDelegate() -> LoginControllerTransitionDelegate?
    
}

public extension LoginComponentsFactory {

    public func createLogInCredentialsValidator() -> LoginCredentialsValidator {
        return LoginCredentialsValidator()
    }
    
    public func createLoginViewModel<SessionService: SessionServiceType>(sessionService: SessionService, credentialsValidator: LoginCredentialsValidator) -> LoginViewModelType {
        return LoginViewModel(sessionService: sessionService, credentialsValidator: createLogInCredentialsValidator())
    }
    
    public func createLoginViewDelegate(configuration: LoginViewConfigurationType) -> LoginViewDelegate {
        return DefaultLoginViewDelegate(configuration: configuration)
    }
    
    public func createLoginView(delegate: LoginViewDelegate) -> LoginViewType {
        let view = LoginView.loadFromNib(FrameworkBundle)!
        view.delegate = delegate
        return view
    }
    
    public func createLoginControllerDelegate() -> LoginControllerDelegate {
        return DefaultLoginControllerDelegate()
    }
    
    public func createLoginControllerTransitionDelegate() -> LoginControllerTransitionDelegate? {
        return .None
    }
    
}

public protocol SignupComponentsFactory {
    
    /**
         Creates the sign up credential validator that embodies the criteria that must be met
         so as to enable the sign up for the user.
         
         - Returns: A sign up credentials validator to use for creating the SignupViewModel.
         
         - Note: You can set in SignupConfiguration which textfields to use during signup
            so if you won't use one of them, you don't have to worry about its validator.
     */
    func createSignUpCredentialsValidator() -> SignupCredentialsValidator
    
    /**
         Creates the SignupViewModel to use in the registration process logic.
         
         - Parameters:
            - sessionService: the session service to use for signup action.
            - credentialsValidator: the credentials validator to use for validating
             entries, before enabling the user to sign up.
            - configuration: configuration that defines which textfields should
                be validated.
     
         - Returns: A signup view model that controls the registration logic
            and comunicates with the session service.
            By default, the default SignupViewModel.
     */
    func createSignupViewModel<SessionService: SessionServiceType>(sessionService: SessionService,
                                      credentialsValidator: SignupCredentialsValidator,
                                      configuration: SignupViewConfigurationType) -> SignupViewModelType
    
    /**
         Creates the SignupViewConfiguration to use for setting
         the signup view configuration.
         
         - Returns: A valid signup view configuration to use.
         
         - Attention: There is no default implementation.
     */
    func createSignupViewConfiguration() -> SignupViewConfigurationType
    
    /**
         Creates the SignupViewDelegate to use in configuring the signup view style.
         
         - Parameters:
             - configuration: view configuration that defines the palettes used to
                configure the view and the textfields that should be shown.
     
         - Returns: A signup view delegate that controls the color and font palette
            setting of the view.
            By default, the DefaultSignupViewDelegate.
        
         - Warning: The textfields selected to be shown must be compatible with
            the view provided.
     */
    func createSignupViewDelegate(configuration: SignupViewConfigurationType) -> SignupViewDelegate
    
    /**
         Creates signup view that conforms to the SignupViewType protocol
         and will be use for the signup visual.
     
         - Parameters:
            - delegate: view delegate for configuring the signup view.
         
         - Returns: A valid signup view ready to be used.
            By default, the default SignupView.
     */
    func createSignupView(delegate: SignupViewDelegate) -> SignupViewType
    
    /**
         Creates the signup view controller delegate
         that the signup controller will use to add behaviour
         to certain events, described in SignupControllerDelegate
         protocol.
         
         - Returns: A valid signup controller delegate to use.
            By default, the DefaultSignupControllerDelegate.
     */
    func createSignupControllerDelegate() -> SignupControllerDelegate
    
    /**
         Creates the signup controller transition delegate that
         the signup controller will use to handle transitions
         to other screens (like login).
         
         - Returns: A valid login controller transition delegate to use,
             or .None if wanting to use the Coordinator's default
             implementation of the protocol.
             By default, returns .None.
     */
    func createSignupControllerTransitionDelegate() -> SignupControllerTransitionDelegate?
    
    /**
         Creates the terms and services view controller delegate
         that can inject behaviour for when the terms and services
         page starts loading and ends loading.
         
         - Returns: A valid terms and services controller delegate to use.
            By default, the DefaultTermsAndServicesControllerDelegate.
     */
    func createTermsAndServicesControllerDelegate() -> TermsAndServicesControllerDelegate
    
}

extension SignupComponentsFactory {
    
    public func createSignUpCredentialsValidator() -> SignupCredentialsValidator {
        return SignupCredentialsValidator()
    }
    
    public func createSignupViewModel<SessionService: SessionServiceType>(sessionService: SessionService,
                                      credentialsValidator: SignupCredentialsValidator,
                                      configuration: SignupViewConfigurationType) -> SignupViewModelType {
        return SignupViewModel(sessionService: sessionService,
                               credentialsValidator: credentialsValidator,
                               passwordConfirmationEnabled: configuration.passwordConfirmationEnabled,
                               usernameEnabled: configuration.usernameEnabled)
    }
    
    public func createSignupViewDelegate(configuration: SignupViewConfigurationType) -> SignupViewDelegate {
        return DefaultSignupViewDelegate(configuration: configuration)
    }
    
    public func createSignupView(delegate: SignupViewDelegate) -> SignupViewType {
        let view = SignupView.loadFromNib(FrameworkBundle)!
        view.delegate = delegate
        return view
    }
    
    public func createSignupControllerDelegate() -> SignupControllerDelegate {
        return DefaultSignupControllerDelegate()
    }
    
    public func createSignupControllerTransitionDelegate() -> SignupControllerTransitionDelegate? {
        return .None
    }
    
    public func createTermsAndServicesControllerDelegate() -> TermsAndServicesControllerDelegate {
        return DefaultTermsAndServicesControllerDelegate()
    }
    
}
