WolMo - Authentication iOS
==========================

[![Build Status](https://travis-ci.org/Wolox/wolmo-authentication-ios.svg?branch=master)](https://travis-ci.org/Wolox/wolmo-authentication-ios)
[![Coverage Status](https://coveralls.io/repos/github/Wolox/wolmo-authentication-ios/badge.svg?branch=master)](https://coveralls.io/github/Wolox/wolmo-authentication-ios?branch=master)
![Swift 2.2.x](https://img.shields.io/badge/Swift-2.2.x-orange.svg)


**Wolmo - Authentication iOS** is an authentication framework for Swift, designed to take care of some basic steps present in almost every iOS app:

- [x] Signup
- [x] Login
- [ ] Recover password (in a future version)

It provides logic as well as default views with plenty extensibility points.

## Table of Contents
* [Installation](#installation)
	* [Carthage](#carthage)
	* [Manually](#manually)
* [Bootstrap](#bootstrap)
* [Dependencies](#dependencies)
* [Usage](#usage)
	* [How to create the AuthenticationCoordinator?](#how-to-create-the-authenticationcoordinator)
		* [Session Service](#session-service)
		* [Authentication Components Factory](#authentication-components-factory)
	* [Getting started](#getting-started)
* [Reporting Issues](#reporting-issues)
* [Contributing](#contributing)
* [About](#about)
* [License](#license)
* [Change Log](#change-log)


## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager that builds your dependencies and provides you with binary frameworks that you can include in your project.

You can install Carthage with Homebrew using the following command:

```
brew update
brew install carthage
```

To download wolmo-core-iOS, add this to your Cartfile:

```
github "Wolox/wolmo-authentication-ios" "master"
```
//TODO: change for release version.

### Manually
[Bootstrap](#bootstrap) the project and then drag it to your workspace.


## Bootstrap

1. Clone the project.
2. Run the bootstrap script that comes with it.

With SSH: 

```
git clone git@github.com:Wolox/wolmo-authentication-ios.git
```

Or with HTTPS:

```
git clone https://github.com/Wolox/wolmo-authentication-ios.git
```

And then:

```
cd wolmo-authentication-ios
script/bootstrap
```



## Dependencies

- [WolmoCore](https://github.com/Wolox/wolmo-core-ios): Framework with useful basic extensions.
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa): Framework inspired by functional reactive programming.
- [Rex](https://github.com/neilpa/Rex): Extensions for ReactiveCocoa.



## Usage

For more information about the framework's structure and concepts, see the [Framework Overview](FRAMEWORK-OVERVIEW.txt).

There is an example application in this project called [AuthenticationDemo](AuthenticationDemo/AppDelegate.swift) in which the basic usage of the framework is shown.

To use anything the framework offers, after installing it you just need to add `import Authentication` to your code, as you would do with any other library.

The framework provides an `AuthenticationCoordinator` class that takes care of managing the authentication process and starting your app.

So in your `AppDelegate.swift` file you will need to

1. create the `AuthenticationCoordinator`
2. trigger its `start` method

and that's all !

This will start the authentication process or redirect to your app if there is no need to authenticate.


### How to create the `AuthenticationCoordinator`?

 The `AuthenticationCoordinator` needs four things to be created:

1. The UIWindow where the app will be shown.
2. Which authentication screen you want to be shown first (login or signup).
3. A session service with which the framework interacts for managing the user session.
4. A component factory that provides the components for the framework to work with.



#### Session Service

You must provide a session service that comforms to the [SessionServiceType](Authentication/SessionServiceType.swift) protocol, which basically stores the current user and has endpoints for logging in and signing up with certain information (acquired by the framework from the final user).


#### Authentication Components Factory

There are many components that the framework will use, and you can configure many things about them.
The [AuthenticationComponentsFactoryType](Authentication/AuthenticationComponentsFactory.swift) protocol ensures a factory method for each of this components.

Almost all of the components have a default implementation, except for a few that are intrinsic to your app:

* **MainViewController**: The UIViewController to show when the authentication is completed. This will be the entry point of your app.
* **LoginViewConfiguration**: Stores the logo and the color and font palettes to style the authentication login screen.
* **SignupViewConfiguration**: Stores the color and font palettes to style the authentication signup screen, but also the URL where to find your terms and services and the textfields you want to use for signup (email and password are mandatory but username and password confirmation are optional).

There is an `AuthenticationComponentsFactory` that provides a way to use all default implementations and easily configure these 3 required elements.


### Getting started

With all we've learned, we can start playing with the framework just by including the following code in your `AppDelegate` class.


```
var authenticationCoordinator: AuthenticationCoordinator<MyUser, MySessionService>!

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let sessionService = MySessionService()
    let logo = UIImage(named: "logo")!
    let termsAndServices = NSURL(string: "https://www.hackingwithswift.com")!
    let componentsFactory = AuthenticationComponentsFactory(logo: logo, termsAndServicesURL: termsAndServices) { return MyMainViewController() }
    authenticationCoordinator = AuthenticationCoordinator(sessionService: sessionService, window: window!, componentsFactory: componentsFactory)
    authenticationCoordinator.start()
    return true
}
```

You should have declared appropriate `MyUser`, `MySessionService` and `MyMainViewController`.

You can see how this works in the basic [Demo Application](AuthenticationDemo/AppDelegate.swift) example this project includes.



## Reporting Issues

Issues may serve for reporting bugs, requesting features or discussing implemented features.

1. Search through existing issues to make sure you are not duplicating one.
2. Write an appropriate title (think of how you would search for something like that).
3. Write an appropriate comment that includes the following details:
	* Short summary
	* Piece of code causing the bug (if it's a bug report)
	* Context or problem identified that could be solved/improved (if it's a feature request or feature modification)
	* Expected result
	* Actual result




## Contributing

1. Fork this repository.
2. [Bootstrap](#bootstrap) the forked repository (instead of `Wolox/wolmo-core-ios.git`, use `your-user/wolmo-core-ios.git`).
3. Create your feature branch (`git checkout -b my-new-feature`).
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Run tests (`./script/test`).
6. Push your branch (`git push origin my-new-feature`).
7. Create a new Pull Request with an appropriate description that includes the following details:
	* Short summary
	* Context or problem identified that is solved/improved
	* Expected result
	* Actual result




## Change Log

You can check the file [CHANGELOG.md](CHANGELOG.md) for detailed information.


## About
This project is maintained by [Daniela Paula Riesgo](https://github.com/danielaRiesgo) and it is written by [Wolox](http://www.wolox.com.ar).


![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)



## License

**WolMo - Authentication iOS** is available under the MIT [license](LICENSE.md).

	Copyright (c) [2016] [Daniela Paula Riesgo]<daniela.riesgo>@wolox.com.ar>
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.





