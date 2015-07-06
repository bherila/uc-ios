//
//  OfferCell.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/26/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class OfferCell : UICollectionViewCell
{
	
	@IBOutlet weak var offerImage: UIImageView!
	@IBOutlet weak var wineryLabel: UILabel!
	@IBOutlet weak var offerTitle: UILabel!
	@IBOutlet weak var buyTitle: UILabel!
	
	func setUp(var todaysOffersController: TodaysOffersController, var itemJson:JSON) {
		var itemImageJson =  itemJson["offerImageUrl"];
		var itemWineryName = itemJson["wineryName"];
		var itemTitle = itemJson["title"];
		var itemImageUrl = "https://ucassets.blob.core.windows.net/offer-img/\(itemImageJson)";
		
		let upgradeValue: Int32 = itemJson["maxPrice"].int32Value;
		let price: Int32 = itemJson["pricePerBottle"].int32Value;
		
		wineryLabel.text = "\(itemWineryName)".uppercaseString;
		offerTitle.text = "\(itemTitle)";
		offerImage.image = todaysOffersController.imageCache[itemImageUrl];
		buyTitle.text = "Buy for $\(price), upgrades to $\(upgradeValue)";
		offerImage?.image = UIImage(named: "Blank52");
		
		// If this image is already cached, don't re-download
		if let img = todaysOffersController.imageCache[itemImageUrl] {
			offerImage?.image = img
		}
		else {
			// The image isn't cached, download the img data
			// We should perform this in a background thread
			let request: NSURLRequest = NSURLRequest(URL: NSURL(string: itemImageUrl)!)
			let mainQueue = NSOperationQueue.mainQueue()
			NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
				if error == nil {
					// Convert the downloaded data in to a UIImage object
					let image = UIImage(data: data)
					// Store the image in to our cache
					todaysOffersController.imageCache[itemImageUrl] = image
					// Update the cell
					dispatch_async(dispatch_get_main_queue(), {
						self.offerImage?.image = image
					})
				}
				else {
					println("Error: \(error.localizedDescription)")
				}
			})
		}
		
	}
	
}
