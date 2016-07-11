//
//  LoginController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Rex
import enum Result.NoError


/**
    Log In View Controller that takes care of managing the login, from
    validating email and password fields, to binding a login view to the
    view model and informing the log in controller delegate when certain
    events occur for it to act upon them.
    If there are more than one errors in a field, the controller presents
    only the first one in the errors label.
 */
public final class LoginController: UIViewController {
    
    private let _viewModel: LoginViewModelType
    private let _transitionDelegate: LoginControllerTransitionDelegate
    private let _loginViewFactory: () -> LoginViewType
    private let _delegate: LoginControllerDelegate

    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    private let _notificationCenter: NSNotificationCenter = .defaultCenter()
    private var _disposable = CompositeDisposable()
    private let _keyboardDisplayed = MutableProperty(false)
    private let _activeField = MutableProperty<UITextField?>(.None)
    
    /**
        Initializes a login controller with the configuration to use:
     
        Parameters:
            - configuration: A login controller configuration with all
                    elements needed to operate.
     
        - Returns: A valid login view controller ready to use.
    */
    init(configuration: LoginControllerConfiguration) {
        _viewModel = configuration.viewModel
        _loginViewFactory = configuration.viewFactory
        _transitionDelegate = configuration.transitionDelegate
        _delegate = configuration.delegate
        super.init(nibName: nil, bundle: nil)
        addKeyboardObservers()
    }
    
    deinit {
        _disposable.dispose()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = loginView.view
    }

    
    public override func viewDidLoad() {
        loginView.render()
        bindViewModel()
        navigationController?.navigationBarHidden = true
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
}

private extension LoginController {
    
    func bindViewModel() {
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        
        _viewModel.logInExecuting.observeNext { [unowned self] executing in
            if executing {
                self._delegate.loginControllerWillExecuteLogIn(self)
            } else {
                self._delegate.loginControllerDidExecuteLogIn(self)
            }
            self.loginView.logInButtonPressed = executing
        }
        
        _viewModel.logInErrors.observeNext { [unowned self] in self._delegate.loginController(self, didLogInWithError: $0) }
    }
    
    func bindEmailElements() {
        _viewModel.email <~ loginView.emailTextField.rex_textSignal
        if let label = loginView.emailLabel {
            label.text = _viewModel.emailText
        }
        loginView.emailTextField.placeholder = _viewModel.emailPlaceholderText
        _viewModel.emailValidationErrors.signal.observeNext { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.loginControllerDidPassEmailValidation(self)
            } else {
                self._delegate.loginController(self, didFailEmailValidationWithErrors: errors)
            }
        }
        if let emailValidationMessageLabel = loginView.emailValidationMessageLabel {
            emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? " " }
        }
        loginView.emailTextField.delegate = self
    }
    
    func bindPasswordElements() {
        _viewModel.password <~ loginView.passwordTextField.rex_textSignal.on(next: { [unowned self] text in
            if text.isEmpty {
                self.loginView.passwordVisibilityButton?.hidden = true
            } else {
                self.loginView.passwordVisibilityButton?.hidden = false
            }
        })
        if let label = loginView.passwordLabel {
            label.text = _viewModel.passwordText
        }
        loginView.passwordTextField.placeholder = _viewModel.passwordPlaceholderText
        _viewModel.passwordValidationErrors.signal.observeNext { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.loginControllerDidPassPasswordValidation(self)
            } else {
                self._delegate.loginController(self, didFailPasswordValidationWithErrors: errors)
            }

        }
        if let passwordValidationMessageLabel = loginView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        if let passwordVisibilityButton = loginView.passwordVisibilityButton {
            passwordVisibilityButton.rex_title <~ _viewModel.showPassword.producer.map { [unowned self] _ in self._viewModel.passwordVisibilityButtonTitle }
            passwordVisibilityButton.rex_pressed.value = _viewModel.togglePasswordVisibilityCocoaAction
            _viewModel.showPassword.signal.observeNext { [unowned self] in self.loginView.showPassword = $0 }
        }
        loginView.passwordTextField.delegate = self
    }
    
    func bindButtons() {
        loginView.logInButton.setTitle(_viewModel.loginButtonTitle, forState: .Normal)
        loginView.logInButton.rex_pressed.value = _viewModel.logInCocoaAction
        loginView.logInButton.rex_enabled.signal.observeNext { [unowned self] in self.loginView.logInButtonEnabled = $0 }
        
        loginView.signupLabel.text = _viewModel.signupLabelText
        loginView.signupButton.setTitle(_viewModel.signupButtonTitle, forState: .Normal)
        loginView.signupButton.setAction { [unowned self] _ in self._transitionDelegate.didTapOnSignup(self) }
        
        loginView.recoverPasswordButton.setTitle(_viewModel.recoverPasswordButtonTitle, forState: .Normal)
        loginView.recoverPasswordButton.setAction { [unowned self] _ in self._transitionDelegate.didTapOnRecoverPassword(self) }
    }

}

extension LoginController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            if _viewModel.logInCocoaAction.enabled {
                textField.resignFirstResponder()
                _viewModel.logInCocoaAction.execute("")
            } else {
                loginView.emailTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if textField == loginView.emailTextField {
            loginView.emailTextFieldSelected = true
        } else {
            loginView.passwordTextFieldSelected = true
        }
        _activeField.value = textField
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if textField == loginView.emailTextField {
            loginView.emailTextFieldSelected = false
        } else {
            loginView.passwordTextFieldSelected = false
        }
        _activeField.value = .None
    }
    
}

extension LoginController {
    
    public func addKeyboardObservers() {
        _disposable += _keyboardDisplayed <~ _notificationCenter
            .rac_notifications(UIKeyboardDidHideNotification)
            .map { _ in false }
        
        _disposable += _notificationCenter
            .rac_notifications(UIKeyboardWillShowNotification)
            .startWithNext { [unowned self] in self.keyboardWillShow($0) }
        
        _disposable += _notificationCenter
            .rac_notifications(UIKeyboardWillHideNotification)
            .startWithNext { [unowned self] _ in self.view.frame.origin.y = 0 }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            if !_keyboardDisplayed.value {
                _keyboardDisplayed.value = true
                let keyboardOffset = keyboardSize.height
                let textFieldOffset = calculateTextFieldOffsetToMoveFrame(keyboardOffset)
                if textFieldOffset > keyboardOffset {
                    view.frame.origin.y -= keyboardOffset
                } else {
                    view.frame.origin.y -= textFieldOffset
                }
                
                view.frame.origin.y += navBarOffset()
            }
        }
    }
    
    func navBarOffset() -> CGFloat {
        let statusBarHeight = UIApplication .sharedApplication().statusBarFrame.height
        let navBarHeight: CGFloat
        if navigationController?.navigationBarHidden ?? true {
            navBarHeight = 0
        } else {
            navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        }
        return navBarHeight + statusBarHeight
    }
    
    /**
        As both textfields fit in all devices, it will always show the email
        textfield at the top of the screen.
    */
    func calculateTextFieldOffsetToMoveFrame(keyboardOffset: CGFloat) -> CGFloat {
        return loginView.emailTextField.convertPoint(loginView.emailTextField.frame.origin, toView: self.view).y - 10
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
