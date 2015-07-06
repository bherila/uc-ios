//
//  OfferDetailViewController.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/26/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class OfferDetailViewController : UIViewController, UIWebViewDelegate
{
	var itemJson: JSON = [];
	var todaysOffersController: TodaysOffersController! = nil;
	
	@IBOutlet weak var webView: UIWebView!
	
	override func viewWillAppear(animated: Bool) {
		let offerSef = itemJson["url"].stringValue
		let requestUrl = NSURL(string: "http://ucwebtier-prod.azurewebsites.net/buy/\(offerSef)?src=app")
		let request = NSURLRequest(URL: requestUrl!)
		println(requestUrl)
		webView.loadRequest(request)
	}
	
	override func viewDidLoad() {
		self.webView.delegate = self
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		println("navigation type: \(navigationType), url: \(request.URL)")
		if let var ss = request.URLString.rangeOfString("buy") {
			// offer detail page
			return true
		}
		else {
			println("type: link clicked")
			UIApplication.sharedApplication().openURL(request.URL!)
			return false
		}
	}
	
}
