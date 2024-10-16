//
//  WebView.swift
//  VKClient
//
//  Created by Александр Минк on 30.09.2024.
//

import SwiftUI
import WebKit

class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView

    init(parent: WebView) {
        self.parent = parent
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString.contains("access_token") {
                parent.viewModel.handleCallback(url: url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: AuthViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = viewModel.loginURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

