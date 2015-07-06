//
//  LiveFeedViewController.swift
//  UCApp
//
//  Created by Benjamin Herila on 7/5/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class LiveFeedViewController : UITableViewController
{
	var offerSef = ""
	var liveFeed: JSON = []
	var defaultText = "Loading"
	var defaultAccessoryType = UITableViewCellAccessoryType.None
	
	override func viewDidLoad() {
		var inset = UIEdgeInsetsMake(64, 0, 64, 0)
		self.automaticallyAdjustsScrollViewInsets = false
		self.tableView.delegate = self
		self.tableView.contentInset = inset;
	}
	
	override func viewWillAppear(animated: Bool) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
				var url = app.midtierBase + "api/offer/detail/" + self.offerSef
				Alamofire.request(.GET, url).responseJSON {(req, res, json, error) in
					if (error != nil) {
						NSLog("Error: \(error)")
						println(req)
						println(res)
						self.err();
					}
					else {
						NSLog("Live feed success: \(url)")
						dispatch_async(dispatch_get_main_queue()) {
							self.liveFeed = JSON(json!)["liveFeed"]
							println("Live feed got \(self.liveFeed.count) items from server")
						}
					}
					dispatch_async(dispatch_get_main_queue()) {
						self.defaultText = "Be the first to buy"
						self.defaultAccessoryType = UITableViewCellAccessoryType.DisclosureIndicator
						self.tableView?.reloadData()
					}
				}
			}
			else {
				self.err();
			}
		}
	}
	
	func err() {
		self.liveFeed = []
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCellWithIdentifier("SimpleTableItem") as? UITableViewCell {
			if let label = cell.textLabel {
				if (liveFeed.count > 0) {
					var liveFeedItem = liveFeed[indexPath.row]
					var name = liveFeedItem["name"].stringValue
					var qty = liveFeedItem["quantity"].stringValue
					label.text = "\(name) bought \(qty)"
					cell.tag = indexPath.row
					if let url = liveFeedItem["url"].string {
						cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
					}
					else {
						cell.accessoryType = UITableViewCellAccessoryType.None
					}
				}
				else {
					label.text = defaultText
					cell.accessoryType = defaultAccessoryType
				}
				return cell
			}
		}
		else {
			println("couldn't deque cell")
		}
		return UITableViewCell()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println("Setting tableview item count to \(liveFeed.count)")
		return max(1, liveFeed.count)
	}
	
	override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
		return 0
	}
	
	override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if let url = liveFeed[indexPath.row]["url"].URL {
			if let formatUrl = NSURL(string: "https://www.undergroundcellar.com/cloudcellar/\(url)") {
				UIApplication.sharedApplication().openURL(formatUrl)
			}
		}
		else {
			if let t: OfferDetailTabViewController = self.parentViewController as? OfferDetailTabViewController {
				t.selectedIndex = 0
			}
		}
		return nil
	}
	
}
