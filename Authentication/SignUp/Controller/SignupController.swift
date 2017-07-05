//
//  SignupController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import GoogleSignIn

/**
     Signup View Controller that takes care of managing the signup, from
     validating all fields, to binding a signup view to the view model
     and informing the signup controller delegate when certain events 
     occur for it to act upon them.
     If there are more than one validation error in a field, the controller
     presents only the first one in the errors label.
 */
public final class SignupController: UIViewController, GIDSignInUIDelegate {
    
    public lazy var signupView: SignupViewType = self._signupViewFactory()
    
    fileprivate let _viewModel: SignupViewModelType
    fileprivate let _signupViewFactory: () -> SignupViewType
    fileprivate let _delegate: SignupControllerDelegate //swiftlint:disable:this weak_delegate
    fileprivate let _transitionDelegate: SignupControllerTransitionDelegate //swiftlint:disable:this weak_delegate
    
    fileprivate let _notificationCenter: NotificationCenter = .default
    fileprivate var _disposable = CompositeDisposable()
    fileprivate let _keyboardDisplayed = MutableProperty(false)
    fileprivate let _activeTextField = MutableProperty<UITextField?>(.none)

    /**
         Initializes a signup controller with the configuration to use.
         
         - Parameter configuration: A signup controller configuration with all
         elements needed to operate.
     */
    internal init(configuration: SignupControllerConfiguration) {
        _delegate = configuration.delegate
        _viewModel = configuration.viewModel
        _signupViewFactory = configuration.viewFactory
        _transitionDelegate = configuration.transitionDelegate
        super.init(nibName: .none, bundle: .none)
        addKeyboardObservers()
    }

    deinit {
        _disposable.dispose()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = signupView.view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        signupView.render()
        bindViewModel()
        navigationController?.isNavigationBarHidden = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _viewModel.bindProviders()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _viewModel.unbindProviders()
    }
    
}

fileprivate extension SignupController {
    
    fileprivate func bindViewModel() {
        bindUsernameElements()
        bindEmailElements()
        bindPasswordElements()
        bindButtons()
        checkTextFieldsSelection()
        hideUnselectedTextfields()
        setTextfieldOrder()
        
        _viewModel.signUpExecuting.observeValues { [unowned self] executing in
            executing
                ? self._delegate.willExecuteSignUp(in: self)
                : self._delegate.didExecuteSignUp(in: self)
            self.signupView.signUpButtonPressed = executing
            for providerButton in self.signupView.loginProviderButtons {
                providerButton.alpha = executing ? 0.5 : 1
                providerButton.isUserInteractionEnabled = !executing
            }
        }
        
        _viewModel.signUpErrors.observeValues { [unowned self] in self._delegate.didFailSignUp(in: self, with: $0) }
        _viewModel.signUpSuccessful.observeValues { [unowned self] _ in self._transitionDelegate.onSignupSuccess(from: self) }
    }
    
    fileprivate func bindUsernameElements() {
        if let usernameTextField = signupView.usernameTextField {
            _viewModel.username <~ usernameTextField.reactive.continuousTextValues.map { $0 ?? "" }
            _viewModel.usernameValidationErrors.signal.observeValues { [unowned self] errors in
                if errors.isEmpty {
                    self._delegate.didPassUsernameValidation(in: self)
                } else {
                    self._delegate.didFailUsernameValidation(in: self, with: errors)
                }
                self.signupView.usernameTextFieldValid = errors.isEmpty
            }
            if let usernameValidationMessageLabel = signupView.usernameValidationMessageLabel {
                usernameValidationMessageLabel.reactive.text <~ _viewModel.usernameValidationErrors.signal.map { $0.first ?? "" }
            }
            usernameTextField.delegate = self
        }
    }
    
    fileprivate func bindEmailElements() {
        _viewModel.email <~ signupView.emailTextField.reactive.continuousTextValues.map { $0 ?? "" }
        _viewModel.emailValidationErrors.signal.observeValues { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassEmailValidation(in: self)
            } else {
                self._delegate.didFailEmailValidation(in: self, with: errors)
            }
            self.signupView.emailTextFieldValid = errors.isEmpty
        }
        if let emailValidationMessageLabel = signupView.emailValidationMessageLabel {
            emailValidationMessageLabel.reactive.text <~ _viewModel.emailValidationErrors.signal.map { $0.first ?? "" }
        }
        signupView.emailTextField.delegate = self
    }
    
    fileprivate func bindPasswordElements() {
        _viewModel.password <~ signupView.passwordTextField.reactive.continuousTextValues
                .map { $0 ?? "" }
                .on(value: { [unowned self] text in
                    self.signupView.passwordVisibilityButton?.isHidden = text.isEmpty
                })
        _viewModel.passwordValidationErrors.signal.observeValues { [unowned self] errors in
            if errors.isEmpty {
                self._delegate.didPassPasswordValidation(in: self)
            } else {
                self._delegate.didFailPasswordValidation(in: self, with: errors)
            }
            self.signupView.passwordTextFieldValid = errors.isEmpty
        }
        if let passwordValidationMessageLabel = signupView.passwordValidationMessageLabel {
            passwordValidationMessageLabel.reactive.text <~ _viewModel.passwordValidationErrors.signal.map { $0.first ?? "" }
        }
        if let passwordVisibilityButton = signupView.passwordVisibilityButton {
            passwordVisibilityButton.reactive.pressed = _viewModel.togglePasswordVisibility
            _viewModel.passwordVisible.signal.observeValues { [unowned self] in self.signupView.passwordVisible = $0 }
        }
        signupView.passwordTextField.delegate = self
        bindPasswordConfirmationElements()
    }
    
    fileprivate func bindPasswordConfirmationElements() {
        if let passwordConfirmationTextField = signupView.passwordConfirmTextField {
            _viewModel.passwordConfirmation <~ passwordConfirmationTextField.reactive.continuousTextValues
                .map { $0 ?? "" }
                .on(value: { [unowned self] text in
                self.signupView.passwordConfirmVisibilityButton?.isHidden = text.isEmpty
            })
            _viewModel.passwordConfirmationValidationErrors.signal.observeValues { [unowned self] errors in
                if errors.isEmpty {
                    self._delegate.didPassPasswordConfirmationValidation(in: self)
                } else {
                    self._delegate.didFailPasswordConfirmationValidation(in: self, with: errors)
                }
                self.signupView.passwordConfirmationTextFieldValid = errors.isEmpty
            }
            if let passwordConfirmValidationMessageLabel = signupView.passwordConfirmValidationMessageLabel {
                passwordConfirmValidationMessageLabel.reactive.text <~ _viewModel.passwordConfirmationValidationErrors.signal.map { $0.first ?? "" }
            }
            if let confirmPasswordVisibilityButton = signupView.passwordConfirmVisibilityButton {
                confirmPasswordVisibilityButton.reactive.pressed = _viewModel.togglePasswordConfirmVisibility
                _viewModel.passwordConfirmationVisible.signal.observeValues { [unowned self] in self.signupView.passwordConfirmationVisible = $0 }
            }
            passwordConfirmationTextField.delegate = self
        }
    }
    
    fileprivate func bindButtons() {
        signupView.signUpButton.reactive.pressed = _viewModel.signUpCocoaAction
        _viewModel.signUpCocoaAction.isEnabled.signal.observeValues { [unowned self] in self.signupView.signUpButtonEnabled = $0 }
        signupView.loginButton.setAction { [unowned self] _ in self._transitionDelegate.toLogin(from: self) }
        bindTermsAndServices()
    }
    
    fileprivate func bindTermsAndServices() {
        signupView.termsAndServicesTextView.delegate = self
    }

    fileprivate func setTextfieldOrder() {
        signupView.usernameTextField?.nextTextField = signupView.emailTextField
        signupView.emailTextField.nextTextField = signupView.passwordTextField
        signupView.passwordTextField.nextTextField = passwordNextTextfield
        signupView.passwordConfirmTextField?.nextTextField = _viewModel.usernameEnabled ? signupView.usernameTextField : signupView.emailTextField
        lastTextField.returnKeyType = .go
    }
    
    fileprivate var passwordNextTextfield: UITextField? {
        if _viewModel.passwordConfirmationEnabled {
            return signupView.passwordConfirmTextField
        } else {
            if _viewModel.usernameEnabled {
                return signupView.usernameTextField
            } else {
                return signupView.emailTextField
            }
        }
    }
    
    fileprivate var lastTextField: UITextField {
        return _viewModel.passwordConfirmationEnabled ? signupView.passwordConfirmTextField! : signupView.passwordTextField
    }
    
    fileprivate func hideUnselectedTextfields() {
        if !_viewModel.usernameEnabled {
            signupView.hideUsernameElements()
        }
        if !_viewModel.passwordConfirmationEnabled {
            signupView.hidePasswordConfirmElements()
        }
    }
    
    fileprivate func checkTextFieldsSelection() {
        if _viewModel.usernameEnabled && signupView.usernameTextField == .none {
            NSLog("signup-error.no-username-textfield.fatal-error.log-message".frameworkLocalized)
            fatalError("signup-error.no-username-textfield.fatal-error.message".frameworkLocalized)
        }
        if _viewModel.passwordConfirmationEnabled && signupView.passwordConfirmTextField == .none {
            NSLog("signup-error.no-confirm-password-textfield.fatal-error.log-message".frameworkLocalized)
            fatalError("signup-error.no-confirm-password-textfield.fatal-error.message".frameworkLocalized)
        }
    }
    
}

extension SignupController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async { [unowned self] in
            if textField == self.lastTextField && self._viewModel.signUpCocoaAction.isEnabled.value {
                textField.resignFirstResponder()
                self._viewModel.signUpCocoaAction.execute(UIButton())
            } else {
                textField.nextTextField?.becomeFirstResponder()
            }

        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [unowned self] in
            if textField == self.signupView.usernameTextField {
                self.signupView.usernameTextFieldSelected = true
            } else if textField == self.signupView.emailTextField {
                self.signupView.emailTextFieldSelected = true
            } else if textField == self.signupView.passwordTextField {
                self.signupView.passwordTextFieldSelected = true
            } else {
                self.signupView.passwordConfirmationTextFieldSelected = true
            }
            self._activeTextField.value = textField
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [unowned self] in
            if textField == self.signupView.usernameTextField {
                self.signupView.usernameTextFieldSelected = false
            } else if textField == self.signupView.emailTextField {
                self.signupView.emailTextFieldSelected = false
            } else if textField == self.signupView.passwordTextField {
                self.signupView.passwordTextFieldSelected = false
            } else {
                self.signupView.passwordConfirmationTextFieldSelected = false
            }
            self._activeTextField.value = .none
        }
    }
    
}

extension SignupController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        _transitionDelegate.onTermsAndServices(from: self)
        return false
    }
    
}

fileprivate extension SignupController {

    fileprivate func addKeyboardObservers() {
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
    
    private func navigationBarOffset() -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight: CGFloat
        if navigationController?.isNavigationBarHidden ?? true {
            navBarHeight = 0
        } else {
            navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        }
        return navBarHeight + statusBarHeight
    }
    
    private func calculateTextFieldOffsetToMoveFrame(_ keyboardOffset: CGFloat, navBarOffset: CGFloat) -> CGFloat {
        let topTextField = signupView.usernameTextField ?? signupView.emailTextField
        let top = topTextField.convert(topTextField.frame.origin, to: self.view).y - 10
        let bottomTextField = signupView.passwordConfirmTextField ?? signupView.passwordTextField
        let bottom = bottomTextField.convert(bottomTextField.frame.origin, to: self.view).y + bottomTextField.frame.size.height
        if (keyboardOffset + (bottom - top) + navBarOffset) <= self.view.frame.size.height {
            return top
        } else {
            return _activeTextField.value!.convert(_activeTextField.value!.frame.origin, to: self.view).y - 10
        }
    }
    
    @objc fileprivate func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
