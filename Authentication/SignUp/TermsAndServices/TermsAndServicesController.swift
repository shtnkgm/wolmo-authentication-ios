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
    
    private let _url: NSURL
    private let _delegate: TermsAndServicesControllerDelegate
    private var _webView: WKWebView!
    
    internal init(url: NSURL, delegate: TermsAndServicesControllerDelegate) {
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
        let request = NSURLRequest(URL: _url)
        _webView.loadRequest(request)
        _delegate.didStartLoadingTermsAndServices(self)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }
        
    // Called when a mainframe load completes.
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        _delegate.didEndLoadingTermsAndServices(self)
    }
    
}
