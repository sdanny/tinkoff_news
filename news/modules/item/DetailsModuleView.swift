//
//  DetailsModuleView.swift
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright (c) 2018 Daniyar Salakhutdinov. All rights reserved.
//

import UIKit
import WebKit

protocol DetailsModuleViewOutput {
    func shouldAllowNavigating(to url: URL?) -> Bool
}

class DetailsModuleView: UIViewController, DetailsModuleViewInput, WKNavigationDelegate {
    
    var output: DetailsModuleViewOutput!
      
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var topIndicator: UIActivityIndicatorView!
    private let indicator = ActivityIndicatorController.indicator()
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    // MARK: input methods
    func presentActivityIndicator(text: String) {
        indicator.text = text
        indicator.present(in: view)
    }
    
    func dismissActivityIndicator() {
        indicator.dismiss()
    }
    
    func setContent(_ content: String) {
        topIndicator.stopAnimating()
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    // MARK: web view navigation delegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        topIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        topIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let allowed = output.shouldAllowNavigating(to: navigationAction.request.url)
        let decision: WKNavigationActionPolicy = allowed ? .allow : .cancel
        decisionHandler(decision)
    }
}
