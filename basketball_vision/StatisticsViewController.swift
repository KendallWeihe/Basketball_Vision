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
        let users = self.ref.child("users")
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let shooting_percentage = value["shooting_percentage"] as! Double
            print("SHOOTING PERCENTAGE = ")
            print(shooting_percentage)
            
        })
    }
    
    @IBAction func get_num_threes(sender: AnyObject) {
        print("get_num_threes")
        let users = self.ref.child("users")
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let num_threes = value["num_threes"] as! NSInteger
            print("NUM THREES = ")
            print(num_threes)
            
        })
    }
    
    @IBAction func get_num_twos(sender: AnyObject) {
        print("get_num_twos")
        let users = self.ref.child("users")
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let num_twos = value["num_twos"] as! NSInteger
            print("NUM TWOS = ")
            print(num_twos)
            
        })
    }
    
    @IBAction func simulate_made_three(sender: AnyObject) {
        print("simulate_made_three")
        let users = self.ref.child("users")
//        let user = users.child(global_email)
//        print(user)
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let num_points = value["num_points"] as! NSInteger
            let num_threes = value["num_threes"] as! NSInteger
            let total_num_shots = value["total_num_shots"] as! Double
            let total_num_made_shots = value["total_num_made_shots"] as! Double
            users.child(self.global_email).child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("num_points").setValue(num_points+3)
            users.child(self.global_email).child("num_threes").setValue(num_threes+1)
            users.child(self.global_email).child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("total_num_made_shots").setValue(total_num_made_shots+1)
        })
    }
    
    @IBAction func simulate_made_two(sender: AnyObject) {
        print("simulate_made_two")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let num_points = value["num_points"] as! NSInteger
            let num_twos = value["num_twos"] as! NSInteger
            let total_num_shots = value["total_num_shots"] as! Double
            let total_num_made_shots = value["total_num_made_shots"] as! Double
            users.child(self.global_email).child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("num_points").setValue(num_points+2)
            users.child(self.global_email).child("num_twos").setValue(num_twos+1)
            users.child(self.global_email).child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("total_num_made_shots").setValue(total_num_made_shots+1)
        })
    }
    
    @IBAction func simulate_missed_shot(sender: AnyObject) {
        print("simulate_missed_shot")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            let value = snapShot.value as! NSDictionary
            let total_num_shots = value["total_num_shots"] as! Double
            let total_num_made_shots = value["total_num_made_shots"] as! Double
            users.child(self.global_email).child("shooting_percentage").setValue(total_num_made_shots/(total_num_shots+1))
            users.child(self.global_email).child("total_num_shots").setValue(total_num_shots+1)
        })
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
        var firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        if (firebaseEmail == ""){
            firebaseEmail = "kendallweihe@gmail&com"
        }
        global_email = firebaseEmail
        
        let users = self.ref.child("users")
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            if (snapShot.exists() == false){
                let fullName = appDelegate.fullName
                let userID = appDelegate.userId
                
                let newUser = ["name" : fullName,
                    "userID" : userID,
                    "num_points": 0,
                    "total_num_shots": 0.0,
                    "total_num_made_shots": 0.0,
                    "shooting_percentage": 1.0,
                    "num_threes": 0,
                    "num_twos": 0]
                
                let currentUser = users.child(firebaseEmail)
                currentUser.setValue(newUser)
                print(currentUser)
                
                let unFirebaseEmailArray = firebaseEmail.componentsSeparatedByString("&")
                let unFirebaseEmail = unFirebaseEmailArray.joinWithSeparator(".")
                print(unFirebaseEmail) // Back to original email
            }
        })
 
        

    
        
    
        
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
