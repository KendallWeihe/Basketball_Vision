//
//  StatisticsViewController.swift
//  basketball_vision
//
//  Created by Kendall Weihe on 10/16/16.
//  Copyright © 2016 Kendall Weihe. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabaseUI

class StatisticsViewController: UIViewController {

    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    var email = String()
    var fullName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        email = appDelegate.email
        fullName = appDelegate.fullName
        
        let users = self.ref.child("users")
        let temp = self.ref.child("basketball-vision-8db77")
        self.ref.child("users").setValue(["user_email": email])
        self.ref.child("users").setValue(["full_name": fullName])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
