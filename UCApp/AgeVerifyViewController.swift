//
//  ViewController.swift
//  UCApp
//
//  Created by Benjamin Herila on 6/1/15.
//  Copyright (c) 2015 Underground Cellar. All rights reserved.
//

import UIKit

class AgeVerifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var agePicker: UIDatePicker!
    
    @IBAction func verifyAgeButton(sender: UIButton) {
        
        println(agePicker.date);
        
        performSegueWithIdentifier("AgeVerified", sender: sender);
    }

    

}

