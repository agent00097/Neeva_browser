//
//  ViewController.swift
//  Neeva Browser
//
//  Created by agent97 on 3/23/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, UISearchBarDelegate, WKNavigationDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var browserWindow: WKWebView!
    
    var currentWebView: WKWebView!
    var errorView: UIView = UIView()
    var errrorLabel: UILabel = UILabel()

    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var browserWindow: UIView!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    func delegSearchBar() {
        searchBar.delegate = self
    }
    
    func workWithWebView() {
        let webAtt = WKWebViewConfiguration()
        let frame = CGRect(x: 0.0, y: 0.0, width: browserWindow.frame.width, height: browserWindow.frame.height)
        currentWebView = WKWebView(frame: frame, configuration: webAtt)
        currentWebView.navigationDelegate = self
        browserWindow.addSubview(currentWebView)
    }
    
    func webViewError() {
        var frame = CGRect(x: 0.0, y: 0.0, width: browserWindow.frame.width, height: browserWindow.frame.height)
        errorView = UIView(frame: frame)
        errorView.backgroundColor = UIColor.white
        
        frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        errrorLabel = UILabel(frame: frame)
        errrorLabel.backgroundColor = UIColor.white
        errrorLabel.textColor = UIColor.black
        errrorLabel.text = "Error Encountered"
        errrorLabel.textAlignment = .center
        errrorLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        errrorLabel.numberOfLines = 0
        
    }
    
    func loadWebsite(_ input: String,_ formatNeeded: Bool) {
        var encURL: String = input
        if (formatNeeded) {
            if(encURL.starts(with: "http://")) {
                encURL = String(encURL.dropFirst(7))
            } else if encURL.starts(with: "https://"){
                encURL = String(encURL.dropFirst(8))
            }
        } else {
            encURL = "https://www.google.com/search?dcr=0&q=" + encURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        let urlToOpen: URL = URL(string: "\(encURL)")!
        let urlRequest: URLRequest = URLRequest(url: urlToOpen)
        currentWebView.load(urlRequest)
        stopWebViewError()
        searchBar.text = encURL.lowercased()
    }
    
    func startWebViewError(_ doku: String) {
        errrorLabel.text = doku
        browserWindow.addSubview(errorView)
        browserWindow.addSubview(errrorLabel)
    }
    
    func stopWebViewError() {
        errorView.removeFromSuperview()
        errrorLabel.removeFromSuperview()
    }
    
    //Rendering functions
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Just to test")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("When finished")
        updateNavButton()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("started")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        startWebViewError(error.localizedDescription)
        updateNavButton()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    
    //bookmarkButton action
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        if (errorView.isDescendant(of: browserWindow)) {
            stopWebViewError()
        }
        else {
        if currentWebView.canGoBack {
            currentWebView.goBack()
            
            
        }
            searchBar.text = currentWebView.url?.absoluteString        }
    }

    func updateNavButton() {
        if (currentWebView.canGoForward) {
            forwardButton.isEnabled = true
        }
        else {
            forwardButton.isEnabled = false
        }
        if (currentWebView.canGoBack) {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    @IBAction func reloadButton(_ sender: Any) {
        currentWebView.reload()
    }
    @IBAction func forwardButton(_ sender: Any) {
        if currentWebView.canGoForward {
            currentWebView.goForward()
            stopWebViewError()
            searchBar.text = currentWebView.url?.absoluteString
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        var searchQuery: String = (searchBar.text?.trimmingCharacters(in: .whitespaces))!
        
        if (!searchQuery.isEmpty) {
            if (searchQuery.hasSuffix(".com") || searchQuery.hasSuffix(".com/")) {
                loadWebsite(searchQuery, true)
            }
            else {
                loadWebsite(searchQuery, false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        delegSearchBar()
        workWithWebView()
        webViewError()
        
        
        loadWebsite("https://mysterious-gorge-99398.herokuapp.com", true)
        
        //browserWindow.load(URLRequest(url: defaultURL))
        
    }


}

