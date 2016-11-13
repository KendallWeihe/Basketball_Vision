//
//  HorseViewController.swift
//  basketball_vision
//
//  Created by Kendall Weihe on 10/16/16.
//  Copyright © 2016 Kendall Weihe. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class HorseViewController: UIViewController {
    
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    // declare global variable email -- unique user identifier
    var global_email = String()
    
    //[START viewDidLoad]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HORSE")
        
        // declare Firebase database reference object
        ref = FIRDatabase.database().reference()
        
        // assign user email (in firebase form) to the global variable global_email
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let email = appDelegate.email // email from delegate
        var firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        if (firebaseEmail == ""){ // this is added for testing purposes
            firebaseEmail = "kendallweihe@gmail&com"
        }
        global_email = firebaseEmail
        // Do any additional setup after loading the view.
    }
    //[END viewDidLoad]

    // the below function is a default function for iOS dev -- included for future developement
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // action to read the instrctions to the user
    @IBAction func read_instructions(sender: AnyObject) {
        // define one giant string that is the instructions
        let instructions = "Establish an order, and take turns shooting the basketball. If the player before you made their shot, then you have to make the same exact shot. If you miss the shot, then you gain a letter in the word horse. If you miss enough shots to where you have spelled the word horse, then you have lost. The last player standing wins."
        
        // read the string aloud
        let utterance = AVSpeechUtterance(string: instructions)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    // action to start the game
    @IBAction func start_game(sender: AnyObject) {
        // eventually -- initialize a game session in the database here
        
        // read aloud to the user that a game has been started
        let utterance = AVSpeechUtterance(string: "You have started the game")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    // action to tell the user who's turn it is
    @IBAction func whos_turn(sender: AnyObject) {
        // eventually -- query the database and find the current game and who's turn it is here
        
        // read aloud to the user who's turn it is
        let utterance = AVSpeechUtterance(string: "It is Kendall's turn")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }
    
    // action to tell the current user their score
    @IBAction func my_current_score(sender: AnyObject) {
        // eventually -- query the database and find the current game, user, and their score here
        
        // read the score aloud to the user
        let utterance = AVSpeechUtterance(string: "You currently have the letters, h, o, r, s")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speakUtterance(utterance)
    }

    // action to simulate a made two point shot
    @IBAction func simulate_made_two(sender: AnyObject) {
        print("simulate_made_two")
        let users = self.ref.child("users") // get users node from database
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get the current values from the entire history of stats
            let value = snapShot.value as! NSDictionary // get the users database info in dictionary form
            let num_points = value["stats"]!["num_points"] as! NSInteger // get number of points
            let num_twos = value["stats"]!["num_twos"] as! NSInteger // get number of two pointers
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double // get total number of shots
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double // get total number of made shots
            
            // update the database with new values
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("num_points").setValue(num_points+2)
            users.child(self.global_email).child("stats").child("num_twos").setValue(num_twos+1)
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("stats").child("total_num_made_shots").setValue(total_num_made_shots+1)
            
            // get the current values from the current sessions stats
            let session_num_points = value["session"]!["num_points"] as! NSInteger
            let session_num_twos = value["session"]!["num_twos"] as! NSInteger
            let session_total_num_shots = value["session"]!["total_num_shots"] as! Double
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! Double
            
            // update the database with new values
            users.child(self.global_email).child("session").child("shooting_percentage").setValue((session_total_num_made_shots+1)/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("num_points").setValue(session_num_points+2)
            users.child(self.global_email).child("session").child("num_twos").setValue(session_num_twos+1)
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            users.child(self.global_email).child("session").child("total_num_made_shots").setValue(session_total_num_made_shots+1)
            
        })
    }
    
    // action to simulate a made three pointer
    @IBAction func simulate_made_three(sender: AnyObject) {
        print("simulate_made_three")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get values in database from entire history stats
            let value = snapShot.value as! NSDictionary
            let num_points = value["stats"]!["num_points"] as! NSInteger
            let num_threes = value["stats"]!["num_threes"] as! NSInteger
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double
            
            // update values in the database
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue((total_num_made_shots+1)/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("num_points").setValue(num_points+3)
            users.child(self.global_email).child("stats").child("num_threes").setValue(num_threes+1)
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            users.child(self.global_email).child("stats").child("total_num_made_shots").setValue(total_num_made_shots+1)
            
            // get values in database from current session stats
            let session_num_points = value["session"]!["num_points"] as! NSInteger
            let session_num_threes = value["session"]!["num_threes"] as! NSInteger
            let session_total_num_shots = value["session"]!["total_num_shots"] as! NSInteger
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! NSInteger
            
            // update values in the database
            users.child(self.global_email).child("session").child("shooting_percentage").setValue((session_total_num_made_shots+1)/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("num_points").setValue(session_num_points+3)
            users.child(self.global_email).child("session").child("num_threes").setValue(session_num_threes+1)
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            users.child(self.global_email).child("session").child("total_num_made_shots").setValue(session_total_num_made_shots+1)
            
        })

    }
    
    // action to simulate a missed shot
    @IBAction func simulate_missed_shot(sender: AnyObject) {
        print("simulate_missed_shot")
        let users = self.ref.child("users")
        //        let user = users.child(global_email)
        //        print(user)
        
        // get snapshot of current user information
        users.child(global_email).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            //print(snapShot)
            
            // get values in database from entire history stats
            let value = snapShot.value as! NSDictionary
            let total_num_shots = value["stats"]!["total_num_shots"] as! Double
            let total_num_made_shots = value["stats"]!["total_num_made_shots"] as! Double
            
            // update values in database
            users.child(self.global_email).child("stats").child("shooting_percentage").setValue(total_num_made_shots/(total_num_shots+1))
            users.child(self.global_email).child("stats").child("total_num_shots").setValue(total_num_shots+1)
            
            // get values in database from current session stats
            let session_total_num_shots = value["session"]!["total_num_shots"] as! Double
            let session_total_num_made_shots = value["session"]!["total_num_made_shots"] as! Double
            
            // update values in the database
            users.child(self.global_email).child("session").child("shooting_percentage").setValue(session_total_num_made_shots/(session_total_num_shots+1))
            users.child(self.global_email).child("session").child("total_num_shots").setValue(session_total_num_shots+1)
            
        })
    }
    
    
}
