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
    
    public lazy var signupView: RegisterViewType = self._registerViewFactory()
    
    
    private lazy var _notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    private var _disposable = CompositeDisposable()
    private let _keyboardDisplayed = MutableProperty(false)

    
    init(viewModel: RegisterViewModelType, registerViewFactory: () -> RegisterViewType) {
        _viewModel = viewModel
        _registerViewFactory = registerViewFactory
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
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

private extension RegisterController {
    
    func bindViewModel() {
        bindNameElements()
    }
    
    func bindNameElements() {
        _viewModel.name <~ signupView.usernameTextField.rex_textSignal
        signupView.usernameLabel.text = _viewModel.nameText
        signupView.usernameTextField.placeholder = _viewModel.namePlaceholderText
//        _viewModel.nameValidationErrors.signal.observeNext { [unowned self] errors in
//            //TODO delegate
//        }
        if let nameValidationMessageLabel = signupView.emailValidationMessageLabel {
            nameValidationMessageLabel.rex_text <~ _viewModel.nameValidationErrors.signal.map { $0.first ?? " " }
        }
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
                let nameOffset = (CGFloat) (-10) //TODO
                if nameOffset > keyboardOffset {
                    self.view.frame.origin.y -= keyboardOffset
                } else {
                    self.view.frame.origin.y -= nameOffset
                }
                let navBarOffset = (self.navigationController?.navigationBarHidden ?? true) ? 0 : self.navigationController?.navigationBar.frame.size.height ?? 0
                self.view.frame.origin.y += navBarOffset
            }
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        if _keyboardDisplayed.value {
            _keyboardDisplayed.value = false
            self.view.endEditing(true)
        }
    }
    
}
