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

    @IBAction func get_num_points(sender: AnyObject) {
        print("get_num_points")
        let users = self.ref.child("users")
//        let user = users.child(global_email)
//        print(user)
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let num_points = value["num_points"] as! NSInteger
            print("NUM POINTS = ")
            print(num_points)
            
        })
    }
    
    @IBAction func get_shooting_percentage(sender: AnyObject) {
        print("get_shooting_percetange")
    }
    
    @IBAction func get_num_threes(sender: AnyObject) {
        print("get_num_threes")
    }
    
    @IBAction func get_num_twos(sender: AnyObject) {
        print("get_num_twos")
    }
    
    @IBAction func simulate_made_three(sender: AnyObject) {
        print("simulate_made_three")
        let users = self.ref.child("users")
        //        let num_points = users.child(global_email).child("num_points")
        //        print(num_points)
        let user = users.child(global_email)
        print(user)
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            
            print(snapShot)
            let value = snapShot.value as! NSDictionary
            let username = value["name"] as! String ?? ""
            let num_points = value["num_points"] as! NSInteger
            users.child(self.global_email).child("num_points").setValue(num_points+3)
            
            
        })
    }
    
    @IBAction func simulate_made_two(sender: AnyObject) {
        print("simulate_made_two")
    }
    
    @IBAction func simulate_missed_shot(sender: AnyObject) {
        print("simulate_missed_shot")
    }
    
    
    
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    var global_email = String()
    var fullName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            GIDSignIn.sharedInstance().signInSilently()
        }
        
        ref = FIRDatabase.database().reference()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let email = appDelegate.email // email from delegate
        let firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        //global_email = firebaseEmail
        global_email = "kendallweihe@gmail&com"
        
        let fullName = appDelegate.fullName
        let userID = appDelegate.userId
        
        let newUser = ["name" : fullName,
                       "userID" : userID,
                       "num_points": 0,
                       "shooting_percentage": 100,
                       "num_threes": 0,
                       "num_twos": 0]
        
        let users = self.ref.child("users")
        if (firebaseEmail != ""){
            let currentUser = users.child(firebaseEmail)
            currentUser.setValue(newUser)
            print(currentUser)
            
            let unFirebaseEmailArray = firebaseEmail.componentsSeparatedByString("&")
            let unFirebaseEmail = unFirebaseEmailArray.joinWithSeparator(".")
            print(unFirebaseEmail) // Back to original email
        }

        
    
        
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
