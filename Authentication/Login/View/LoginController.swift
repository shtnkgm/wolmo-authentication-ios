//
//  LoginController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

/**
    Login View Controller that takes care of managing the login, from
    validating email and password fields, to binding a login view to the
    view model and informing the login controller delegate when certain
    events occur for it to act upon them.
    If there are more than one validation error in a field, the controller
    presents only the first one in the errors label.
 */
public final class LoginController: UIViewController {
    
    public lazy var loginView: LoginViewType = self._loginViewFactory()
    
    fileprivate let _viewModel: LoginViewModelType
    fileprivate let _transitionDelegate: LoginControllerTransitionDelegate //swiftlint:disable:this weak_delegate
    private let _loginViewFactory: () -> LoginViewType
    fileprivate let _delegate: LoginControllerDelegate //swiftlint:disable:this weak_delegate
    
    fileprivate let _notificationCenter: NotificationCenter = .default
    fileprivate var _disposable = CompositeDisposable()
    fileprivate let _keyboardDisplayed = MutableProperty(false)
    fileprivate let _activeField = MutableProperty<UITextField?>(.none)
    
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
        loginView.render()
        bindViewModel()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}

private extension LoginController {
    
    func bindViewModel() {
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        setTextfieldOrder()
        
        _viewModel.logInExecuting.observeValues { [unowned self] executing in
            executing
                ? self._delegate.willExecuteLogIn(in: self)
                : self._delegate.didExecuteLogIn(in: self)
            self.loginView.logInButtonPressed = executing
        }
        
        _viewModel.logInErrors.observeValues { [unowned self] in self._delegate.didLogIn(in: self, with: $0) }
        _viewModel.logInSuccessful.observeValues { [unowned self] _ in self._transitionDelegate.onLoginSuccess(from: self) }
    }
    
    private func bindEmailElements() {
        _viewModel.email <~ loginView.emailTextField.reactive.textValues.map { $0 ?? "" }
        _viewModel.emailValidationErrors.signal.observeValues { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassEmailValidation(in: self)
            } else {
                self._delegate.didFailEmailValidation(in: self, with: errors)
            }
            self.loginView.emailTextFieldValid = errors.isEmpty
        }
        if let emailValidationMessageLabel = loginView.emailValidationMessageLabel {
            emailValidationMessageLabel.reactive.text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? "" }
        }
        loginView.emailTextField.delegate = self
    }
    
    private func bindPasswordElements() {
        _viewModel.password <~ loginView.passwordTextField.reactive.textValues
            .map { $0 ?? "" }
            .on(value: { [unowned self] text in
            self.loginView.passwordVisibilityButton?.isHidden = text.isEmpty
        })
        _viewModel.passwordValidationErrors.signal.observeValues { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassPasswordValidation(in: self)
            } else {
                self._delegate.didFailPasswordValidation(in: self, with: errors)
            }
            self.loginView.passwordTextFieldValid = errors.isEmpty
        }
        if let passwordValidationMessageLabel = loginView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.reactive.text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? "" }
        }
        if let passwordVisibilityButton = loginView.passwordVisibilityButton {
            passwordVisibilityButton.reactive.pressed = _viewModel.togglePasswordVisibility
            _viewModel.passwordVisible.signal.observeValues { [unowned self] in self.loginView.passwordVisible = $0 }
        }
        loginView.passwordTextField.delegate = self
    }
    
    private func bindButtons() {
        loginView.logInButton.reactive.pressed = _viewModel.logInCocoaAction
        _viewModel.logInCocoaAction.isEnabled.signal.observeValues { [unowned self] in self.loginView.logInButtonEnabled = $0 }
        loginView.signupButton.setAction { [unowned self] _ in self._transitionDelegate.toSignup(from: self) }
        loginView.recoverPasswordButton.setAction { [unowned self] _ in self._transitionDelegate.toRecoverPassword(from: self) }
    }
    
    private func setTextfieldOrder() {
        loginView.emailTextField.nextTextField = loginView.passwordTextField
        loginView.passwordTextField.nextTextField = loginView.emailTextField
    }
    
    var lastTextField: UITextField {
        return loginView.passwordTextField
    }

}

extension LoginController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lastTextField && _viewModel.logInCocoaAction.isEnabled.value {
            textField.resignFirstResponder()
            _viewModel.logInCocoaAction.execute(UIButton())
        } else {
            textField.nextTextField?.becomeFirstResponder()
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginView.emailTextField {
            loginView.emailTextFieldSelected = true
        } else {
            loginView.passwordTextFieldSelected = true
        }
        _activeField.value = textField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == loginView.emailTextField {
            loginView.emailTextFieldSelected = false
        } else {
            loginView.passwordTextFieldSelected = false
        }
        _activeField.value = .none
    }
    
}

private extension LoginController {
    
    func addKeyboardObservers() {
        _disposable += _keyboardDisplayed <~ _notificationCenter
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardDidHide)
            .map { _ in false }
        
        _disposable += _notificationCenter
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardWillShow)
            .observeValues { [unowned self] in self.keyboardWillShow($0) }
        
        _disposable += _notificationCenter
            .reactive.notifications(forName: NSNotification.Name.UIKeyboardWillHide)
            .observeValues { [unowned self] _ in self.view.frame.origin.y = 0 }
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !_keyboardDisplayed.value {
                _keyboardDisplayed.value = true
                let keyboardOffset = keyboardSize.height
                let textFieldOffset = calculateTextFieldOffsetToMoveFrame(withKeyboardOffset: keyboardOffset)
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
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat
        if navigationController?.isNavigationBarHidden ?? true {
            navBarHeight = 0
        } else {
            navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        }
        return navBarHeight + statusBarHeight
    }
    
    /* As both textfields fit in all devices, it will always show the email
    textfield at the top of the screen. */
    private func calculateTextFieldOffsetToMoveFrame(withKeyboardOffset: CGFloat) -> CGFloat {
        return loginView.emailTextField.convert(loginView.emailTextField.frame.origin, to: self.view).y - 10
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
