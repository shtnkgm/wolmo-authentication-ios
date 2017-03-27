//
//  TermsAndServicesControllerDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/26/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/*
     Protocol for terms and services controller delegates.
     Create your own delegate and override any of
     the defaut methods to add behaviour to your
     terms and services HTML loading and presenting process.
 */
public protocol TermsAndServicesControllerDelegate {    //swiftlint:disable:this class_delegate_protocol

    /**
        Function called when the terms and services content starts loading.
     
        By default, it activates the Network Activity Indicator in the status bar.
     
        - Parameter controller: TermsAndServicesController where the event is happening.
     */
    func didStartLoadingTermsAndServices(in controller: TermsAndServicesController)

    /**
        Function called when the terms and services content finished loading.
     
        By default, it deactivates the Network Activity Indicator in the status bar.
     
        - Parameter controller: TermsAndServicesController where the event is happening.
     */
    func didEndLoadingTermsAndServices(in controller: TermsAndServicesController)

}

public extension TermsAndServicesControllerDelegate {
    
    public func didStartLoadingTermsAndServices(in controller: TermsAndServicesController) {
        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = true
    }

    public func didEndLoadingTermsAndServices(in controller: TermsAndServicesController) {
        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = false
    }

}

public final class DefaultTermsAndServicesControllerDelegate: TermsAndServicesControllerDelegate { } //swiftlint:disable:this type_name
