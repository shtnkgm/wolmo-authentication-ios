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
public protocol TermsAndServicesControllerDelegate {

    /* Function called when the terms and services content starts loading. */
    func didStartLoadingTermsAndServices(controller: TermsAndServicesController)

    /* Function called when the terms and services content finished loading. */
    func didEndLoadingTermsAndServices(controller: TermsAndServicesController)

}

public extension TermsAndServicesControllerDelegate {
    
    /* By default, it activates the Network Activity Indicator in the status bar. */
    public func didStartLoadingTermsAndServices(controller: TermsAndServicesController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = true
    }

    /* By default, it deactivates the Network Activity Indicator in the status bar. */
    public func didEndLoadingTermsAndServices(controller: TermsAndServicesController) {
        let app = UIApplication.sharedApplication()
        app.networkActivityIndicatorVisible = false
    }

}

public final class DefaultTermsAndServicesControllerDelegate: TermsAndServicesControllerDelegate { } //swiftlint:disable:this type_name
