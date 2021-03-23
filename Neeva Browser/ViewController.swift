//
//  ViewController.swift
//  Neeva Browser
//
//  Created by agent97 on 3/23/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var browserWindow: WKWebView!
    
    @IBAction func backButton(_ sender: Any) {
        if browserWindow.canGoBack {
            browserWindow.goBack()
        }
    }

    @IBAction func reloadButton(_ sender: Any) {
        browserWindow.reload()
    }
    @IBAction func forwardButton(_ sender: Any) {
        if browserWindow.canGoForward {
            browserWindow.goForward()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaultURL = URL(string: "https://mysterious-gorge-99398.herokuapp.com")!
        
        browserWindow.load(URLRequest(url: defaultURL))
        
    }


}

