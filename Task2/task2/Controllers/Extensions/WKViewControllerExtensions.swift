//
//  WKViewControllerExtensions.swift
//  task2
//
//  Created by Mphrx on 03/11/21.
//

import Foundation
import WebKit

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(webviewContentHeight != 0)
        {
            return
        }
        webviewContentHeight = webView.scrollView.contentSize.height
        tableView.reloadData()
    }
}
