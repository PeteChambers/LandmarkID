//
//  WebViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 21/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import WebKit
import Foundation

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    var text: String = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://en.wikipedia.org/wiki/\(String(describing: text.replacingOccurrences(of: " ", with: "_")))")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    
    
}
