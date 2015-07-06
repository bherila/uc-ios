//
//  ViewController.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/1/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import UIKit

class AgeVerifyViewController: UIViewController {
	
	@IBOutlet weak var agePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func verifyAgeButton(sender: UIButton) {
		println(agePicker.date);
		
		let age: Double = abs(agePicker.date.timeIntervalSinceDate(NSDate()))
		let ageReq: Double = 21 * 86400 * 365
		if (age < ageReq) {
			let alert = UIAlertView();
			alert.title = "Age Restriction"
			alert.message = "Sorry, you must be 21 years of age to use this app."
			alert.addButtonWithTitle("OK")
			alert.show()
		}
		else {
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "is21yearsOld")
			performSegueWithIdentifier("AgeVerified", sender: sender);
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "AgeVerified") {
			//do any other preparation needed here...
		}
	}
	
}
