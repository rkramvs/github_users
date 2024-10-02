//
//  WebViewController.swift
//  Packages
//
//  Created by Ram Kumar on 02/10/24.
//

import UIKit
import WebKit

public class WebViewController: UIViewController {
    
    var url: URL
    private var webView: WKWebView = WKWebView(frame: .zero)
    
    public init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }
    
    // MARK: - Setup WebView
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Constraints for WebView
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Load URL in WebView
    private func loadURL() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
