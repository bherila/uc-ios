//
//  MainNavigationController.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/2/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController : UINavigationController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class TodaysOffersController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: OfferCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! OfferCell;
        
        let upgradeValue = indexPath.item * 7;
        
        cell.buyTitle.text = "Buy for $\(indexPath.item), upgrades to $\(upgradeValue)";
        
        return cell;
        
    }
    
    var lastItemSelected: Int = -1;
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // push view controller, pass the selected item along
        lastItemSelected = indexPath.item;
        println("clicked item \(lastItemSelected)");
        performSegueWithIdentifier("ShowOffer", sender: self);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // todo: pass clicked item along
        
        if (segue.identifier == "ShowOffer") {
            var vc = segue.destinationViewController as! OfferDetailViewController;
            vc.selIndex = lastItemSelected;
        }
    }
    
}

class OfferCell : UICollectionViewCell
{
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var buyTitle: UILabel!
    
}

class OfferDetailViewController : UITabBarController
{
    var selIndex: Int = -1;
}