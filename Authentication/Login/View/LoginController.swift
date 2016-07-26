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
    Login View Controller that takes care of managing the login, from
    validating email and password fields, to binding a login view to the
    view model and informing the login controller delegate when certain
    events occur for it to act upon them.
    If there are more than one validation error in a field, the controller
    presents only the first one in the errors label.
 
    //TODO: Move what's below to README.
    If wanting to use the default LoginController with some customization,
    you will not override the `createLoginController` method of the Bootstrapper,
    but all the others that provide the elements this controller uses. (That is to say,
    `createLoginView`, `createLoginViewModel`, `createLoginControllerDelegate`
    and/or `createLoginControllerConfiguration`)
 */
public final class LoginController: UIViewController {
    
    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    private let _viewModel: LoginViewModelType
    private let _transitionDelegate: LoginControllerTransitionDelegate
    private let _loginViewFactory: () -> LoginViewType
    private let _delegate: LoginControllerDelegate
    
    private let _notificationCenter: NSNotificationCenter = .defaultCenter()
    private var _disposable = CompositeDisposable()
    private let _keyboardDisplayed = MutableProperty(false)
    private let _activeField = MutableProperty<UITextField?>(.None)
    
    
    /**
        Initializes a login controller with the configuration to use.
     
        - Parameter configuration: A login controller configuration
        with all elements needed to operate.
    */
    internal init(configuration: LoginControllerConfiguration) {
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
        view = loginView.view
    }

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        loginView.render()
        bindViewModel()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
}

private extension LoginController {
    
    private func bindViewModel() {
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        setTextfieldOrder()
        
        _viewModel.logInExecuting.observeNext { [unowned self] executing in
            executing
                ? self._delegate.willExecuteLogIn(self)
                : self._delegate.didExecuteLogIn(self)
            self.loginView.logInButtonPressed = executing
        }
        
        _viewModel.logInErrors.observeNext { [unowned self] in self._delegate.didLogIn(self, with: $0) }
    }
    
    private func bindEmailElements() {
        _viewModel.email <~ loginView.emailTextField.rex_textSignal
        _viewModel.emailValidationErrors.signal.observeNext { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassEmailValidation(self)
            } else {
                self._delegate.didFailEmailValidation(self, with: errors)
            }
            self.loginView.emailTextFieldValid = errors.isEmpty
        }
        if let emailValidationMessageLabel = loginView.emailValidationMessageLabel {
            emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? "" }
        }
        loginView.emailTextField.delegate = self
    }
    
    private func bindPasswordElements() {
        _viewModel.password <~ loginView.passwordTextField.rex_textSignal.on(next: { [unowned self] text in
            self.loginView.passwordVisibilityButton?.hidden = text.isEmpty
        })
        _viewModel.passwordValidationErrors.signal.observeNext { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassPasswordValidation(self)
            } else {
                self._delegate.didFailPasswordValidation(self, with: errors)
            }
            self.loginView.passwordTextFieldValid = errors.isEmpty
        }
        if let passwordValidationMessageLabel = loginView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? "" }
        }
        if let passwordVisibilityButton = loginView.passwordVisibilityButton {
            passwordVisibilityButton.rex_pressed.value = _viewModel.togglePasswordVisibility
            _viewModel.passwordVisible.signal.observeNext { [unowned self] in self.loginView.passwordVisible = $0 }
        }
        loginView.passwordTextField.delegate = self
    }
    
    private func bindButtons() {
        loginView.logInButton.rex_pressed.value = _viewModel.logInCocoaAction
        loginView.logInButton.rex_enabled.signal.observeNext { [unowned self] in self.loginView.logInButtonEnabled = $0 }
        loginView.signupButton.setAction { [unowned self] _ in self._transitionDelegate.onSignup(self) }
        loginView.recoverPasswordButton.setAction { [unowned self] _ in self._transitionDelegate.onRecoverPassword(self) }
    }
    
    private func setTextfieldOrder() {
        loginView.emailTextField.nextTextField = loginView.passwordTextField
        loginView.passwordTextField.nextTextField = loginView.emailTextField
    }
    
    private var lastTextField: UITextField {
        return loginView.passwordTextField
    }

}

extension LoginController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == lastTextField && _viewModel.logInCocoaAction.enabled {
            textField.resignFirstResponder()
            _viewModel.logInCocoaAction.execute("")
        } else {
            textField.nextTextField?.becomeFirstResponder()
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

private extension LoginController {
    
    private func addKeyboardObservers() {
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
    
    private func keyboardWillShow(notification: NSNotification) {
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
    
    private func navBarOffset() -> CGFloat {
        let statusBarHeight = UIApplication .sharedApplication().statusBarFrame.height
        let navBarHeight: CGFloat
        if navigationController?.navigationBarHidden ?? true {
            navBarHeight = 0
        } else {
            navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        }
        return navBarHeight + statusBarHeight
    }
    
    /* As both textfields fit in all devices, it will always show the email
    textfield at the top of the screen. */
    private func calculateTextFieldOffsetToMoveFrame(keyboardOffset: CGFloat) -> CGFloat {
        return loginView.emailTextField.convertPoint(loginView.emailTextField.frame.origin, toView: self.view).y - 10
    }
    
    @objc private func dismissKeyboard(sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
