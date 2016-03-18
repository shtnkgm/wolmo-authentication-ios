//
//  RegisterController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/7/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation


public final class RegisterController: UIViewController {
    
    private let _viewModel: RegisterViewModel
    private let _registerViewFactory: () -> RegisterViewType
    
    public lazy var registerView: RegisterViewType = self._registerViewFactory()
    
    init(viewModel: RegisterViewModel, registerViewFactory: () -> RegisterViewType) {
        _viewModel = viewModel
        _registerViewFactory = registerViewFactory
        
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
