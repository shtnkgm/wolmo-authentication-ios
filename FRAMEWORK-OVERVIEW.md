# Framework Overview

## Introduction

The **Authentication framework** takes care of two primary screens: Login and Signup.

To handle those screens, the framework uses the [MVVM pattern](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/).

This framework is intended to be customizable for the user to adapt it to his/her app. For this, the framework uses the [Delegation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID276) design pattern, also used by Apple's UIKit framework, for example.

Finally, the Authentication framework also uses a functional reactive programming framework ([ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)) which the user will need to use for conforming certain protocols (see [Session Service](#session-service) below).

## Basic Structure

Following the [MVVM pattern](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/), each screen has a View, a View Model and a View Controller, where the View Model is in charge of handling all logic in order to provide all information the view needs to display and the View Controller is in charge of binding the View Model's information to the View's elements.

The user of the **Authentication framework** can provide any view or view model that conforms to certain protocols, but the view controller is fixed. This means that the view controller will bind all information the view model or view provides in conformance to the corresponding view or view model protocol. Any extra functionality or information the user may add to his/her view or view model will not be binded, and so must be _internal_ information of the component (or information used outside this framework).

Moreover, the framework also provides customizable `LoginProvider` functionality as an alternative to common email/username - password login, that may represent any external service for login, as for example, Facebook.
Login providers will appear in login page, and if wanted in signup page as well. As they all provide the same service, only one can be used at a time, so as far as view interaction is concerned, only login attempt will be notified in general. However, the Session Service will be notified exactly from where the login was performed and with which information.

So you will find the following protocols:

* [LoginViewType](Authentication/Login/View/LoginView.swift)
* [LoginViewModelType](Authentication/Login/ViewModel/LoginViewModel.swift)

and

* [SignupViewType](Authentication/SignUp/View/SignupView.swift)
* [SignupViewModelType](Authentication/SignUp/ViewModel/SignupViewModel.swift)

and

* [LoginProvider](Authentication/LoginProviders/LoginProvider.swift)

and the following elements:

* [LoginController](Authentication/Login/View/LoginController.swift) (fixed controller)
* [LoginView](Authentication/Login/View/LoginView.swift) (default view)
* [LoginViewModel](Authentication/Login/ViewModel/LoginViewModel.swift) (default view model)

and

* [SignupController](Authentication/SignUp/View/SignupController.swift) (fixed controller)
* [SignupView](Authentication/SignUp/View/SignupView.swift) (default view)
* [SignupViewModel](Authentication/SignUp/ViewModel/SignupViewModel.swift) (default view model)

and

* [FacebookLoginProvider](Authentication/LoginProviders/Facebook/FacebookLoginProvider.swift)
* [GoogleLoginProvider](Authentication/LoginProviders/Google/GoogleLoginProvider.swift)

The Signup screen has a "child screen" that is used for showing the terms and services of the app (check [Terms and Services](Authentication/SignUp/TermsAndServices/)). This screen is supposed to only show the terms and services to the user and give the possibility to return to sign up. Since it's basic and it's not central, its components are not customizable, just the content is shown (although the content is an HTML that can use javascript).


## Session Service

All screens for finally executing the main action (logging in or signing up a user) will delegate to the `Session Service` provided.

This component must always be designed by the user of this framework and must respond to the functional reactive interface required by the [SessionServiceType](Authentication/SessionServiceType.swift) protocol.
So take a look at the [functional reactive programming](https://github.com/ReactiveCocoa/ReactiveCocoa) framework used. You can also take a look at the [ExampleSessionService](AuthenticationDemo/ExampleSessionService.swift) in the Demo app included in this project.


## Delegates

There are two types of delegates:

* Event delegates
* Transition delegates

The event delegates are the ones that add behaviour to certain events inside a screen, whereas the transition delegates are responsible for executing the transitions between screens.

**Event delegates:**

* [LoginControllerDelegate](Authentication/Login/View/LoginControllerDelegate.swift)
* [SignupControllerDelegate](Authentication/SignUp/View/SignupControllerDelegate.swift)
* [TermsAndServicesControllerDelegate](Authentication/SignUp/TermsAndServices/TermsAndServicesControllerDelegate.swift)


**Transition delegates:**

* [LoginControllerTransitionDelegate](Authentication/Login/View/LoginControllerTransitionDelegate.swift)
* [SignupControllerTransitionDelegate](Authentication/SignUp/View/SignupControllerTransitionDelegate.swift)


## Using Custom Views

If the user wants to use custom views for Login, Sign Up or both, he or she should create a class that implements `AuthenticationComponentsFactoryType` and override the correspondent method (`createLoginView(withDelegate delegate: LoginViewDelegate, loginProviders: [LoginProvider]) -> LoginViewType` for example) and pass it to the `AuthenticationCoordinator` on creation.
The custom view will need to implement `LoginViewType` (or `SignUpViewType`). To implement that protocol the user will also need to implement `Renderable` and `LoginFormType` (or `SignUpFormType`) and that one will also need to implement `AuthenticationFormType`. 
Note that those protocols will ask to implement properties that should match an UI element from the view (`var passwordTextField: UITextField` for example). In those cases the best solution is probably to return an IBOutlet reference of the element.
If the user is using `GoogleLoginProvider`, the ViewController will need to implement the protocol `GIDSignInUIDelegate` and in `viewDidLoad` add the line `GIDSignIn.sharedInstance().uiDelegate = self`.


## Localization

This framework incentivates the user to localize its app. Every text seen in the framework's screens is localized and to change it you only need to create a [Strings file](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html) and localize the key of the text element you want to change, without affecting the rest.

You can find the whole list of keys to localize in the [framework's english strings file](Authentication/Supporting\ Files/en.lproj/Localizable.strings) and you can find an example of custom localization in the [example Demo app's english strings file](AuthenticationDemo/en.lproj/Localizable.strings).
