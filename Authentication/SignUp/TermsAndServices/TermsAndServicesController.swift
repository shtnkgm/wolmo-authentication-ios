//
//  TermsAndServicesController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/15/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import UIKit
import WebKit

/**
     Terms And Services View Controller that takes care of presenting
     the terms and services and informing loading events to delegate.
*/
public final class TermsAndServicesController: UIViewController, WKNavigationDelegate {
    
    fileprivate let _url: URL
    fileprivate let _delegate: TermsAndServicesControllerDelegate //swiftlint:disable:this weak_delegate
    fileprivate var _webView: WKWebView!
    
    internal init(url: URL, delegate: TermsAndServicesControllerDelegate) {
        _url = url
        _delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.minimumFontSize = 7
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        _webView = webView
        view = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: _url)
        _webView.load(request)
        _delegate.didStartLoadingTermsAndServices(self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
        
    // Called when a mainframe load completes.
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _delegate.didEndLoadingTermsAndServices(self)
    }
    
}
