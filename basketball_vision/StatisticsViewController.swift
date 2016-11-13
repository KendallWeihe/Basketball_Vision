//
//  StatisticsViewController.swift
//  basketball_vision
//
//  Created by Kendall Weihe on 10/16/16.
//  Copyright © 2016 Kendall Weihe. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class StatisticsViewController: UIViewController {
    
    
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    // declare global variable used to uniquely identify users -- by email
    var global_email = String()
    
    // [START viewDidLoad()]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sign user in silently
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            GIDSignIn.sharedInstance().signInSilently()
        }
        
        // declare global variable for database reference instance
        ref = FIRDatabase.database().reference()
        
        // assign global variable to uniquely identify user -- via email
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let email = appDelegate.email // email from delegate
        var firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        if (firebaseEmail == ""){ // this is included for testing purposes
            firebaseEmail = "kendallweihe@gmail&com"
        }
        global_email = firebaseEmail // assign global variable
    }
    // [END viewDidLoad()]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // action to get total number of points -- over entire history
    @IBAction func get_num_points(sender: AnyObject) {
        print("get_num_points")
        let users = self.ref.child("users")
        
        // get snapshot of current user information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get number of points over entire history
            let value = snapShot.value as! NSDictionary
            let num_points = value["stats"]!["num_points"] as! NSInteger
            print("NUM POINTS = ")
            print(num_points)
            
            // read the number of points to the user
            let utterance = AVSpeechUtterance(string: "You have made a total of " + String(num_points) + " points")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get overall shooting percentage
    @IBAction func get_shooting_percentage(sender: AnyObject) {
        print("get_shooting_percetange")
        let users = self.ref.child("users")
        
        // get snapshot of current user information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get value of shooting percentage over entire history
            let value = snapShot.value as! NSDictionary
            let shooting_percentage = value["stats"]!["shooting_percentage"] as! Double
            print("SHOOTING PERCENTAGE = ")
            print(shooting_percentage)
            
            // read the shooting percentage to the user
            let utterance = AVSpeechUtterance(string: "You're total shooting percentage is " + String(Int(shooting_percentage*100)) + " percent")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the total number of three pointers
    @IBAction func get_num_threes(sender: AnyObject) {
        print("get_num_threes")
        let users = self.ref.child("users")
        
        // get snapshot of current user information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get overall number of three pointers from snapshot
            let value = snapShot.value as! NSDictionary
            let num_threes = value["stats"]!["num_threes"] as! NSInteger
            print("NUM THREES = ")
            print(num_threes)
            
            // read the number of three pointers to the user
            let utterance = AVSpeechUtterance(string: "You have made " + String(num_threes) + " three pointers total")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the total number of two pointers
    @IBAction func get_num_twos(sender: AnyObject) {
        print("get_num_twos")
        let users = self.ref.child("users")
        
        // get snapshot of current users information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get overall number of two pointers from snapshot
            let value = snapShot.value as! NSDictionary
            let num_twos = value["stats"]!["num_twos"] as! NSInteger
            print("NUM TWOS = ")
            print(num_twos)
            
            // read the number of two pointers to the user
            let utterance = AVSpeechUtterance(string: "You have made " + String(num_twos) + " two pointers total")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the number of points scored in this session
    @IBAction func get_num_session_points(sender: AnyObject) {
        print("get_num_session_points")
        let users = self.ref.child("users")
        
        // get snapshot of current user information from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get the number of points scored in the current session from the snapshot
            let value = snapShot.value as! NSDictionary
            let num_points = value["session"]!["num_points"] as! NSInteger
            print("NUM POINTS = ")
            print(num_points)
            
            // read the number of points in the current session to the user
            let utterance = AVSpeechUtterance(string: "You have made " + String(num_points) + " points during this session")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the shooting percentage for the current session
    @IBAction func get_session_shooting_percentage(sender: AnyObject) {
        print("get_session_shooting_percetange")
        let users = self.ref.child("users")
        
        // get snapshot of current user info from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get the shooting percentage for the current session from the snapshot
            let value = snapShot.value as! NSDictionary
            let shooting_percentage = value["session"]!["shooting_percentage"] as! Double
            print("SHOOTING PERCENTAGE = ")
            print(shooting_percentage)
            
            // read the shooting percentage aloud to the user
            let utterance = AVSpeechUtterance(string: "You're shooting percentage for this game session is " + String(Int(shooting_percentage*100)) + " percent")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the number of three pointers in the current session
    @IBAction func get_session_num_threes(sender: AnyObject) {
        print("get_session_num_threes")
        let users = self.ref.child("users")
        
        // get snapshot of current user from the databse
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get number of threes from the snapshot
            let value = snapShot.value as! NSDictionary
            let num_threes = value["session"]!["num_threes"] as! NSInteger
            print("NUM THREES = ")
            print(num_threes)
            
            // read the number of threes aloud to the user
            let utterance = AVSpeechUtterance(string: "You have made " + String(num_threes) + " three pointers during this game session")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to get the number of two pointers in the current session
    @IBAction func get_session_num_twos(sender: AnyObject) {
        print("get_session_num_twos")
        let users = self.ref.child("users")
        
        // get snapshot of current user from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get the number of two pointers from the snapshot
            let value = snapShot.value as! NSDictionary
            let num_twos = value["session"]!["num_twos"] as! NSInteger
            print("NUM TWOS = ")
            print(num_twos)
            
            // read the number of two pointers aloud to the user
            let utterance = AVSpeechUtterance(string: "You have made " + String(num_twos) + " two pointers during this game session")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speakUtterance(utterance)
        })
    }
    
    // action to simulate a made three pointer
    @IBAction func simulate_made_three(sender: AnyObject) {
        print("simulate_made_three")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get the values in the "stats" node from the snapshot
            let value = snapShot.value as! NSDictionary
            let num_points = value["stats"]!["num_points"] as! NSInteger
            let num_threes = value["stats"]!["num_threes"] as! NSInteger
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double
            
            // update values
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("num_points").setValue(num_points+3)
            users.child(self.global_email).child("stats").child("num_threes").setValue(num_threes+1)
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("stats").child("total_num_made_shots").setValue(total_num_made_shots+1)
            
            // get the values in the "session" node from the snapshot
            let session_num_points = value["session"]!["num_points"] as! NSInteger
            let session_num_threes = value["session"]!["num_threes"] as! NSInteger
            let session_total_num_shots = value["session"]!["total_num_shots"] as! NSInteger
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! NSInteger
            
            // udpate values
            users.child(self.global_email).child("session").child("shooting_percentage").setValue((session_total_num_made_shots+1)/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("num_points").setValue(session_num_points+3)
            users.child(self.global_email).child("session").child("num_threes").setValue(session_num_threes+1)
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            users.child(self.global_email).child("session").child("total_num_made_shots").setValue(session_total_num_made_shots+1)
            
        })
    }
    
    // action to simulate a made two pointer
    @IBAction func simulate_made_two(sender: AnyObject) {
        print("simulate_made_two")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get values from the "stats" node of the snapshot
            let value = snapShot.value as! NSDictionary
            let num_points = value["stats"]!["num_points"] as! NSInteger
            let num_twos = value["stats"]!["num_twos"] as! NSInteger
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double
            
            // update values
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("num_points").setValue(num_points+2)
            users.child(self.global_email).child("stats").child("num_twos").setValue(num_twos+1)
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("stats").child("total_num_made_shots").setValue(total_num_made_shots+1)
            
            // get values from the "session" node of the snapshot
            let session_num_points = value["session"]!["num_points"] as! NSInteger
            let session_num_twos = value["session"]!["num_twos"] as! NSInteger
            let session_total_num_shots = value["session"]!["total_num_shots"] as! Double
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! Double
            
            // update values
            users.child(self.global_email).child("session").child("shooting_percentage").setValue((session_total_num_made_shots+1)/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("num_points").setValue(session_num_points+2)
            users.child(self.global_email).child("session").child("num_twos").setValue(session_num_twos+1)
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            users.child(self.global_email).child("session").child("total_num_made_shots").setValue(session_total_num_made_shots+1)
            
        })
    }
    
    // action to simuate a missed shot
    @IBAction func simulate_missed_shot(sender: AnyObject) {
        print("simulate_missed_shot")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user from the database
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get values in the "stats" node from the snapshot
            let value = snapShot.value as! NSDictionary
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double
            
            // update values
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue(total_num_made_shots/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            
            // get the values in the "session" node from the snapshot
            let session_total_num_shots = value["session"]!["total_num_shots"] as! Double
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! Double
            
            // udpate values
            users.child(self.global_email).child("session").child("shooting_percentage").setValue(session_total_num_made_shots/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            
        })
    }
    
}
