//
//  RegisterController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class RegisterController: UIViewController {
    
    private let _viewModel: RegisterViewModelType
    private let _registerViewFactory: () -> RegisterViewType
    private let _delegate: RegisterControllerDelegate
    
    public lazy var signupView: RegisterViewType = self._registerViewFactory()
    
    private lazy var _notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    private var _disposable = CompositeDisposable()
    private let _keyboardDisplayed = MutableProperty(false)
    private let _activeTextField = MutableProperty<UITextField?>(.None)

    
    init(viewModel: RegisterViewModelType, registerViewFactory: () -> RegisterViewType, delegate: RegisterControllerDelegate = DefaultRegisterControllerDelegate()) {
        _viewModel = viewModel
        _registerViewFactory = registerViewFactory
        _delegate = delegate
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
        self.view = signupView.view
    }
    
    
    public override func viewDidLoad() {
        signupView.render()
        bindViewModel()
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
}

private extension RegisterController {
    
    func bindViewModel() {
        bindNameElements()
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
    }
    
    func bindNameElements() {
        _viewModel.name <~ signupView.usernameTextField.rex_textSignal
        signupView.usernameLabel.text = _viewModel.nameText
        signupView.usernameTextField.placeholder = _viewModel.namePlaceholderText
        _viewModel.nameValidationErrors.signal.observeNext { [unowned self] errors in
            self._delegate.signupController(self, didFailNameValidationWithErrors: errors)
        }
        if let nameValidationMessageLabel = signupView.usernameValidationMessageLabel {
            nameValidationMessageLabel.rex_text <~ _viewModel.nameValidationErrors.signal.map { $0.first ?? " " }
        }
    }
    
    func bindEmailElements() {
        _viewModel.email <~ signupView.emailTextField.rex_textSignal
        signupView.emailLabel.text = _viewModel.emailText
        signupView.emailTextField.placeholder = _viewModel.emailPlaceholderText
        _viewModel.emailValidationErrors.signal.observeNext { [unowned self] errors in
            self._delegate.signupController(self, didFailEmailValidationWithErrors: errors)
        }
        if let emailValidationMessageLabel = signupView.emailValidationMessageLabel {
            emailValidationMessageLabel.rex_text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? " " }
        }
    }
    
    func bindPasswordElements() {
        _viewModel.password <~ signupView.passwordTextField.rex_textSignal
        signupView.passwordLabel.text = _viewModel.passwordText
        signupView.passwordTextField.placeholder = _viewModel.passwordPlaceholderText
        _viewModel.passwordValidationErrors.signal.observeNext { [unowned self] errors in
            self._delegate.signupController(self, didFailPasswordValidationWithErrors: errors)
        }
        if let passwordValidationMessageLabel = signupView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.rex_text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? " " }
        }
        
        _viewModel.passwordConfirmation <~ signupView.passwordConfirmTextField.rex_textSignal
        signupView.passwordConfirmLabel.text = _viewModel.confirmPasswordText
        signupView.passwordConfirmTextField.placeholder = _viewModel.confirmPasswordPlaceholderText
        _viewModel.passwordConfirmationValidationErrors.signal.observeNext { [unowned self] errors in
            self._delegate.signupController(self, didFailPasswordConfirmationValidationWithErrors: errors)
        }
        if let passwordConfirmValidationMessageLabel = signupView.passwordConfirmValidationMessageLabel {
            passwordConfirmValidationMessageLabel.rex_text <~ _viewModel.passwordConfirmationValidationErrors.signal.map { $0.first ?? " " }
        }
    }
    
    func bindButtons() {
        signupView.registerButton.setTitle(_viewModel.signupButtonTitle, forState: .Normal)
        signupView.registerButton.rex_pressed.value = _viewModel.signUpCocoaAction
        signupView.registerButton.rex_enabled.signal.observeNext { [unowned self] in self.signupView.registerButtonEnabled = $0 }
        
        signupView.termsAndServicesLabel.text = _viewModel.termsAndServicesLabelText
        signupView.termsAndServicesButton.setTitle(_viewModel.termsAndServicesButtonTitle, forState: .Normal)
        //signupView.termsAndServicesButton -> Presents the terms and services
    }
    
}

extension RegisterController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == signupView.usernameTextField {
            signupView.emailTextField.becomeFirstResponder()
        } else if textField == signupView.emailTextField {
            signupView.passwordTextField.becomeFirstResponder()
        } else if textField == signupView.passwordTextField {
            signupView.passwordConfirmTextField.becomeFirstResponder()
        } else {
            signupView.usernameTextField.becomeFirstResponder()
        }
        return true
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if textField == signupView.usernameTextField {
            signupView.usernameTextFieldSelected = true
        } else if textField == signupView.emailTextField {
            signupView.emailTextFieldSelected = true
        } else if textField == signupView.passwordTextField {
            signupView.passwordTextFieldSelected = true
        } else {
            signupView.passwordConfirmationTextFieldSelected = true
        }
        _activeTextField.value = textField
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if textField == signupView.usernameTextField {
            signupView.usernameTextFieldSelected = false
        } else if textField == signupView.emailTextField {
            signupView.emailTextFieldSelected = false
        } else if textField == signupView.passwordTextField {
            signupView.passwordTextFieldSelected = false
        } else {
            signupView.passwordConfirmationTextFieldSelected = false
        }
        _activeTextField.value = .None
    }
    
}

extension RegisterController {

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
                let navBarOffset = navigationBarOffset()
                let textFieldOffset = calculateTextFieldOffsetToMoveFrame(keyboardOffset, navBarOffset: navBarOffset)
                if textFieldOffset > keyboardOffset {
                    self.view.frame.origin.y -= keyboardOffset
                } else {
                    self.view.frame.origin.y -= textFieldOffset
                }
                self.view.frame.origin.y += navBarOffset
            }
        }
    }
    
    func navigationBarOffset() -> CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navBarHeight: CGFloat
        if navigationController?.navigationBarHidden ?? true {
            navBarHeight = 0
        } else {
            navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        }
        return navBarHeight + statusBarHeight
    }
    
    func calculateTextFieldOffsetToMoveFrame(keyboardOffset: CGFloat, navBarOffset: CGFloat) -> CGFloat {
        let top = signupView.usernameTextField.convertPoint(signupView.usernameTextField.frame.origin, toView: self.view).y - 10
        let bottom = signupView.passwordConfirmTextField.convertPoint(signupView.passwordConfirmTextField.frame.origin, toView: self.view).y + signupView.passwordConfirmTextField.frame.size.height
        if (keyboardOffset + (bottom - top) + navBarOffset) <= self.view.frame.size.height {
            return top
        } else {
            return _activeTextField.value!.convertPoint(_activeTextField.value!.frame.origin, toView: self.view).y - 10
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
