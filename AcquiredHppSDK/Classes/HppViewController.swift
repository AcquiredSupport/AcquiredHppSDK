
//
//  HppWKWebView.swift
//  Acquired_SDK_IOS
//
//  Created by Xiaoping Li on 2018/9/4.
//  Copyright © 2018 Acquired. All rights reserved.
//

import UIKit
import WebKit


class HppViewController : UIViewController,WKUIDelegate, WKNavigationDelegate,UIWebViewDelegate {
    
    private var hppView : WKWebView?
    public var hppUrl : String?
    
    lazy private var progressView: UIProgressView = {
        let y = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y:y, width: UIScreen.main.bounds.width, height: 2))
        self.progressView.tintColor = UIColor.orange
        self.progressView.trackTintColor = UIColor.white
        return self.progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor  = UIColor.white
        setUpWKwebView()
    }
    
    
    
    func setUpWKwebView() {
        let hppView = WKWebView(frame: UIScreen.main.bounds)
        hppView.scrollView.bounces = false
        
        let escapedString = self.hppUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = NSURL(string: escapedString ?? "")
        let request = NSURLRequest.init(url: url! as URL)
        hppView.load(request as URLRequest)
        
        self.view.addSubview(hppView)
        self.view.addSubview( self.progressView)
        
        self.hppView = hppView
        self.hppView?.navigationDelegate = self
        self.hppView?.uiDelegate = self
        
        self.hppView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.hppView?.estimatedProgress) ?? 0), animated: true)
            if (self.hppView?.estimatedProgress ?? 0.0)  >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
    }
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    deinit {
        self.hppView?.removeObserver(self, forKeyPath: "estimatedProgress")
        self.hppView?.uiDelegate = nil
        self.hppView?.navigationDelegate = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
