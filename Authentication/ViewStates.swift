//
//  ViewStates.swift
//  Authentication
//
//  Created by Daniela Riesgo on 2/14/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import Foundation

internal enum TextFieldContentState {
    case initialEmpty
    case invalid
    case valid
}

internal typealias TextFieldState = (selected: Bool, content: TextFieldContentState)

internal typealias ButtonState = (executing: Bool, enabled: Bool)

// MARK: - Login View
internal typealias LoginViewState = (email: TextFieldState,
                                     password: TextFieldState,
                                     logInButton: ButtonState)

internal enum LoginViewEvent {
    case emailSelected
    case emailUnselected
    case emailValid
    case emailInvalid
    case passwordSelected
    case passwordUnselected
    case passwordValid
    case passwordInvalid
    case logInButtonEnabled
    case logInButtonDisabled
    // "Pressed" implies it started executing
    case logInButtonPressed
    // "Unpressed" would mean stopped executing.
    case logInButtonUnpressed
}

// MARK: - Signup View
internal typealias SignupViewState = (email: TextFieldState,
                                      password: TextFieldState,
                                      username: TextFieldState,
                                      confirmPassword: TextFieldState,
                                      signUpButton: ButtonState)

internal enum SignupViewEvent {
    case emailSelected
    case emailUnselected
    case emailValid
    case emailInvalid
    case passwordSelected
    case passwordUnselected
    case passwordValid
    case passwordInvalid
    case usernameSelected
    case usernameUnselected
    case usernameValid
    case usernameInvalid
    case confirmPasswordSelected
    case confirmPasswordUnselected
    case confirmPasswordValid
    case confirmPasswordInvalid
    case signUpButtonEnabled
    case signUpButtonDisabled
    // "Pressed" implies it started executing
    case signUpButtonPressed
    // "Unpressed" would mean stopped executing.
    case signUpButtonUnpressed
}
