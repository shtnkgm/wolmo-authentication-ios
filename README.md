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
* [Framework Overview](#framework-overview)
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

There is an example application in this project called **AuthenticationDemo** in which the basic usage of the framework is shown.

For being able to use anything the framework offers, after installing it you just need to add `import Authentication` to your code, as any library.

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
4. A component factory that provides the components for the framwork to work with.


...




## Reporting Issues




## Contributing




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





