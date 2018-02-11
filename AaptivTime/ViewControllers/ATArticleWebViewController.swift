//
//  ATArticleWebViewController.swift
//  AaptivTime
//
//  Created by HAO WANG on 2/11/18.
//  Copyright © 2018 HaoWang. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class ATArticleWebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var viewModel: ATArticleItemViewModel

    init(articleItem: NYTimeArticleItem) {
        viewModel = ATArticleItemViewModel(articleItem)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = viewModel.articleItem.url,
            let url = URL(string: urlString)  {

            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ATArticleWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
        PKHUD.sharedHUD.show(onView: view)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        PKHUD.sharedHUD.hide()
    }

    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {

        PKHUD.sharedHUD.contentView = PKHUDErrorView()
        PKHUD.sharedHUD.show(onView: view)
        PKHUD.sharedHUD.hide(afterDelay: 3)
    }
}
