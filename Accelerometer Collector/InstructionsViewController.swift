//
//  InstructionsViewController.swift
//  Accelerometer Collector
//
//  Created by Eduardo Thiesen on 08/08/16.
//  Copyright © 2016 thiesen. All rights reserved.
//

import UIKit
import CoreMotion

class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func allowAccess(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let beginController = storyboard.instantiateViewControllerWithIdentifier("main")
        self.presentViewController(beginController, animated: true, completion: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ALREADY_READ_INSTRUCTIONS")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
