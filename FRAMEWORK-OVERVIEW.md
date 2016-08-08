# Framework Overview

## Introduction

The **Authentication framework** takes care of two primary screens: Login and Signup.

To handle those screens, the framework uses the [MVVM pattern](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/).

This framework is intended to be customizable for the user to adapt it to his/her app. For this, the framework uses the [Delegation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID276) design pattern, also used by Apple's UIKit framework, for example.

Finally, the Authentication framework also uses a functional reactive programming framework ([ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)) which the user will need to use for conforming certain protocols (see [Session Service](#session-service) below).

## Basic Structure

Following the [MVVM pattern](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/), each screen has a View, a View Model and a View Controller, where the View Model is in charge of handling all logic in order to provide all information the view needs to display and the View Controller is in charge of binding the View Model's information to the View's elements and viceversa.

The user of the **Authentication framework** can provide any view or view model that conforms to certain protocols, but the view controller is fixed. This means that the view controller will bind all information the view model or view provides in conformance to the corresponding view or view model protocol. Any extra functionality or information the user may add to his/her view or view model will not be binded, and so must be _internal_ information of the component (or information used outside this framework).

So you will find the following protocols:

* [LoginViewType](Authentication/Login/View/LoginView.swift)
* [LoginViewModelType](Authentication/Login/ViewModel/LoginViewModel.swift)

and

* [SignupViewType](Authentication/Signup/View/SignupView.swift)
* [SignupViewModelType](Authentication/Signup/ViewModel/SignupViewModel.swift)


and the following elements:

* [LoginController](Authentication/Login/View/LoginController.swift) (fixed controller)
* [LoginView](Authentication/Login/View/LoginView.swift) (default view)
* [LoginViewModel](Authentication/Login/ViewModel/LoginViewModel.swift) (default view model)

and

* [SignupController](Authentication/Signup/View/SignupController.swift) (fixed controller)
* [SignupView](Authentication/Signup/View/SignupView.swift) (default view)
* [SignupViewModel](Authentication/Signup/ViewModel/SignupViewModel.swift) (default view model)



The Signup screen has a "child screen" that is used for showing the terms and services of the app. This screen is supposed to only show the terms and services to the user and give the possibility to return to sign up. Since it's basic and it's not central, its components are not customizable, just the content it is shown (although the content is an HTML that can use javascript).


## Session Service

All screens for finally executing the main action (logging in or signing up a user) will delegate to the `Session Service` provided.

This component must always be designed by the user of this framework and must respond to the functional reactive interface required by the [SessionServiceType](Authentication/SessionServiceType.swift) protocol.
So take a look at the [functional reactive programming](https://github.com/ReactiveCocoa/ReactiveCocoa) framework used. You can also take a look at the [ExampleSessionService](AuthenticationDemo/ExampleSessionService.swift) in the Demo app included in this project.


## Delegates

There are two types of delegates:

* Event delegates **_--> Change name!!_**
* Transition delegates

The event delegates are the ones that add behaviour to certain events inside a screen, whereas the transition delegates are responsible for executing the transitions between screens.

**Event delegates:**

* [LoginControllerDelegate](Authentication/Login/View/LoginControllerDelegate.swift)
* [SignupControllerDelegate](Authentication/Signup/View/SignupControllerDelegate.swift)
* [TermsAndServicesControllerDelegate](Authentication/Signup/TermsAndServices/TermsAndServicesControllerDelegate.swift)


**Transition delegates:**

* [LoginControllerTransitionDelegate](Authentication/Login/View/LoginControllerTransitionDelegate.swift)
* [SignupControllerTransitionDelegate](Authentication/Signup/View/SignupControllerTransitionDelegate.swift)





## Localization

This framework incentivates the user to localize its app. Every text seen in the framework's screens is localized and to change it you only need to create a [Strings file](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html) and localize the key of the text element you want to change, withuot affecting the rest.
You can find the whole list of keys to localize in the [framework's english strings file](Authentication/Supporting\ Files/en.lproj/Localizable.strings) and you can find an example of custom localization in the [example Demo app's english strings file](AuthenticationDemo/en.lproj/Localizable.strings).