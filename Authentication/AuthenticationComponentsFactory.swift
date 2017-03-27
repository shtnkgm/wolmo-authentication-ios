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
    private let _loginProviders: [LoginProvider]
    
    /**
        Initializes the AuthenticationComponentsFactory
        with the components to use.
        
        - Parameters:
            - loginConfiguration: login view configuration to
                return when asked for it.
            - signupConfiguration: signup view configuration to
                return when asked for it.
            - loginProviders: alternative providers for login service.
            - mainControllerFactory: main view controller factory
                method to trigger when asked for the main view
                controller.
    */
    public init(loginConfiguration: LoginViewConfigurationType,
                signupConfiguration: SignupViewConfigurationType,
                loginProviders: [LoginProvider] = [],
                mainControllerFactory: @escaping () -> UIViewController) {
        _mainControllerFactory = mainControllerFactory
        _loginConfiguration = loginConfiguration
        _signupConfiguration = signupConfiguration
        _loginProviders = loginProviders
    }
    
    /**
         Initializes the AuthenticationComponentsFactory
         with the components to use.
         
         - Parameters:
             - logo: logo to add to the default LoginViewConfiguration.
             - termsAndServicesURL: terms and services URL used
                to create the default SignupViewConfiguration.
             - loginProviders: alternative providers for login service.
             - mainControllerFactory: main view controller factory
                method to trigger when asked for the main view
                controller.
     */
    public init(logo: UIImage? = .none,
                termsAndServicesURL: URL,
                loginProviders: [LoginProvider] = [],
                mainControllerFactory: @escaping () -> UIViewController) {
        self.init(loginConfiguration: LoginViewConfiguration(logoImage: logo),
                  signupConfiguration: SignupViewConfiguration(termsAndServicesURL: termsAndServicesURL),
                  loginProviders: loginProviders,
                  mainControllerFactory: mainControllerFactory)
    }
    
    public func createMainViewController() -> UIViewController {
        return _mainControllerFactory()
    }
    
    public func createLoginViewConfiguration() -> LoginViewConfigurationType {
        return _loginConfiguration
    }
    
    public func createLoginProviders() -> [LoginProvider] {
        return _loginProviders
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
            - loginProviders: alternative providers for the login service.
     
         - Returns: A login view model that controls the login logic and communicates
            with the session service.
            By default, the default LoginViewModel configured with the arguments received.
     */
    func createLoginViewModel<SessionService: SessionServiceType>(withSessionService sessionService: SessionService,
                                                                  credentialsValidator: LoginCredentialsValidator,
                                                                  loginProviders: [LoginProvider]) -> LoginViewModelType
    
    /**
        Creates the LoginViewConfiguration to use for setting
        the login view configuration.
     
        - Returns: A valid login view configuration to use.
     
        - Attention: There is no default implementation.
    */
    func createLoginViewConfiguration() -> LoginViewConfigurationType
    
    /**
     Creates the login providers to use.
     
     - Returns: An array of valid login providers.
       The default implementation returns an empty list of providers.
     */
    func createLoginProviders() -> [LoginProvider]
    
    /**
         Creates the LoginViewDelegate to use in configuring the login view style.
     
         - Parameters:
            - configuration: view configuration that defines the palettes and logo
            image to configure the view.
         
         - Returns: A login view delegate that controls the color and font palette
             setting of the view.
             By default, the DefaultLoginViewDelegate.
     */
    func createLoginViewDelegate(withConfiguration configuration: LoginViewConfigurationType) -> LoginViewDelegate
    
    /**
         Creates a login view that conforms to the logInViewType protocol
         and will be used for the login visual.
     
         - Parameters:
            - delegate: view delegate for configuring the login view.
            - loginProviders: the alternative providers used for the login service,
                which also provide a button to represent them.
         
     - Returns: A valid signup view ready to be used.
             By default, the view returned is the default LoginView.
     */
    func createLoginView(withDelegate delegate: LoginViewDelegate,
                         loginProviders: [LoginProvider]) -> LoginViewType
    
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
            or .none if wanting to use the Coordinator's default
            implementation of the protocol.
            By default, returns .none.
     */
    func createLoginControllerTransitionDelegate() -> LoginControllerTransitionDelegate?
    
}

public extension LoginComponentsFactory {

    public func createLogInCredentialsValidator() -> LoginCredentialsValidator {
        return LoginCredentialsValidator()
    }
    
    public func createLoginViewModel<SessionService: SessionServiceType>(withSessionService sessionService: SessionService,
                                                                         credentialsValidator: LoginCredentialsValidator,
                                                                         loginProviders: [LoginProvider]) -> LoginViewModelType {
            let providerSignals = loginProviders.map { ($0.userSignal, $0.errorSignal) }
            return LoginViewModel(sessionService: sessionService,
                                  credentialsValidator: createLogInCredentialsValidator(),
                                  providerSignals: providerSignals)
    }
    
    public func createLoginViewDelegate(withConfiguration configuration: LoginViewConfigurationType) -> LoginViewDelegate {
        return DefaultLoginViewDelegate(configuration: configuration)
    }
    
    public func createLoginView(withDelegate delegate: LoginViewDelegate,
                                loginProviders: [LoginProvider]) -> LoginViewType {
        let view: LoginView = LoginView.loadFromNib(inBundle: FrameworkBundle)!
        view.delegate = delegate
        view.loginProviderButtons = loginProviders.map { $0.createButton() }
        return view
    }
    
    public func createLoginControllerDelegate() -> LoginControllerDelegate {
        return DefaultLoginControllerDelegate()
    }
    
    public func createLoginControllerTransitionDelegate() -> LoginControllerTransitionDelegate? {
        return .none
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
            - loginProviders: providers for the login service, alternative to signup.
     
         - Returns: A signup view model that controls the registration logic
            and comunicates with the session service.
            By default, the default SignupViewModel configured with the arguments received.
     */
    func createSignupViewModel<SessionService: SessionServiceType>(withSessionService sessionService: SessionService,
                                                                   credentialsValidator: SignupCredentialsValidator,
                                                                   configuration: SignupViewConfigurationType,
                                                                   loginProviders: [LoginProvider]) -> SignupViewModelType
    
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
    func createSignupViewDelegate(withConfiguration configuration: SignupViewConfigurationType) -> SignupViewDelegate
    
    /**
         Creates a signup view that conforms to the SignupViewType protocol
         and will be used for the signup visual.
     
         - Parameters:
            - delegate: view delegate for configuring the signup view.
            - loginProviders: the alternative providers used for the login/signup service,
                which also provide a button to represent them.
     
         - Returns: A valid signup view ready to be used.
            By default, the view returned is the default SignupView.
     */
    func createSignupView(withDelegate delegate: SignupViewDelegate,
                          loginProviders: [LoginProvider]) -> SignupViewType
    
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
             or .none if wanting to use the Coordinator's default
             implementation of the protocol.
             By default, returns .none.
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
    
    public func createSignupViewModel<SessionService: SessionServiceType>(withSessionService sessionService: SessionService,
                                                                          credentialsValidator: SignupCredentialsValidator,
                                                                          configuration: SignupViewConfigurationType,
                                                                          loginProviders: [LoginProvider]) -> SignupViewModelType {
            let providerUserSignals = loginProviders.map { ($0.userSignal, $0.errorSignal) }
            return SignupViewModel(sessionService: sessionService,
                                   credentialsValidator: credentialsValidator,
                                   usernameEnabled: configuration.usernameEnabled,
                                   passwordConfirmationEnabled: configuration.passwordConfirmationEnabled,
                                   providerSignals: providerUserSignals)
    }
    
    public func createSignupViewDelegate(withConfiguration configuration: SignupViewConfigurationType) -> SignupViewDelegate {
        return DefaultSignupViewDelegate(configuration: configuration)
    }
    
    public func createSignupView(withDelegate delegate: SignupViewDelegate,
                                 loginProviders: [LoginProvider]) -> SignupViewType {
        let view: SignupView = SignupView.loadFromNib(inBundle: FrameworkBundle)!
        view.delegate = delegate
        view.loginProviderButtons = loginProviders.map { $0.createButton() }
        return view
    }
    
    public func createSignupControllerDelegate() -> SignupControllerDelegate {
        return DefaultSignupControllerDelegate()
    }
    
    public func createSignupControllerTransitionDelegate() -> SignupControllerTransitionDelegate? {
        return .none
    }
    
    public func createTermsAndServicesControllerDelegate() -> TermsAndServicesControllerDelegate {
        return DefaultTermsAndServicesControllerDelegate()
    }
    
}
