//
//  TodaysOffersController.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/26/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class TodaysOffersController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate
{
	
	var offerJson: JSON = nil
	var offerImages: [UIImage] = []
	var imageCache = [String:UIImage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		var inset = UIEdgeInsetsMake(32, 0, 32, 0)
		self.collectionView?.contentInset = inset
		
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			
			if let app = UIApplication.sharedApplication().delegate as? AppDelegate {
				var url =  app.midtierBase + "api/offer/"
				
				Alamofire.request(.GET, url)
					.responseJSON { (req, res, json, error) in
						if(error != nil) {
							NSLog("Error: \(error)")
							println(req)
							println(res)
							self.err();
						}
						else {
							NSLog("Success: \(url)")
							
							dispatch_async(dispatch_get_main_queue()) {
								// update some UI
								self.offerJson = JSON(json!)
								println("got \(self.offerJson.count) items from server")
								self.collectionView?.reloadData()
							}
						}
				}
			}
			else {
				self.err();
			}
		}
		
	}
	
	func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
		// critical error delegate
		exit(1);
	}
	
	func err() {
		let alert = UIAlertView()
		alert.title = "Problem"
		alert.message = "Can't get today's offers, please try again later"
		alert.addButtonWithTitle("Ok")
		alert.delegate = self
		alert.show()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		collectionView.registerNib(UINib(nibName: "OfferItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "OfferItemCell");
		
		println("loading \(offerJson.count) items")
		return min(20, offerJson.count)
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OfferItemCell", forIndexPath: indexPath) as? OfferCell
		cell!.setUp(self, itemJson: offerJson[indexPath.item])
		return cell!;
		
	}
	
	var lastItemSelected: Int = -1;
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		// push view controller, pass the selected item along
		lastItemSelected = indexPath.item
		println("clicked item \(lastItemSelected)")
		performSegueWithIdentifier("ShowOffer", sender: self)
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// todo: pass clicked item along
		
		if (segue.identifier == "ShowOffer") {
			
			var item = offerJson[lastItemSelected]
			/*
			var offerSef = item["url"]
			var url = "http://ucwebtier-prod.azurewebsites.net/buy/\(offerSef)"
			UIApplication.sharedApplication().openURL(NSURL(string: url)!)
			*/
			
			var vc = segue.destinationViewController as! OfferDetailTabViewController
			var detailView = vc.childViewControllers[0] as! OfferDetailViewController
			var itemJson = offerJson[lastItemSelected]
			detailView.itemJson = itemJson
			detailView.todaysOffersController = self
			
			var liveFeedView = vc.childViewControllers[1] as! LiveFeedViewController
			liveFeedView.offerSef = itemJson["url"].stringValue
		}
	}
	
}
