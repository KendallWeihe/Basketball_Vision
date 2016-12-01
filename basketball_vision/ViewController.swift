//
//  ViewController.swift
//  basketball_vision
//
//  Created by Kendall Weihe on 10/16/16.
//  Copyright © 2016 Kendall Weihe. All rights reserved.
//
import UIKit
import Firebase
import BluetoothKit

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    // declare global variables to be used throughout the application -- user information
    var userID = String()
    var idToken = String()
    var fullName = String()
    var givenName = String()
    var familyName = String()
    var email = String()

    // declare button outlets
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var gamesButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    // action to handle when the user tapped Sign In
    @IBAction func tappedSignIn(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn() // call library function to sign user in
        
        // assign global variable for email -- the unique user identifier
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        email = appDelegate.email
        get_user_info(email);
    }
    
    // action to handle when the user signed out
    @IBAction func tappedSignOut(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signOut() // call library function to sign user out
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI() // toggle the homescreen buttons
    }
    
    // [START toggle_auth]
        // this function toggles the homescreen buttons 
            // if the user is logged in, then the dashboard navigation buttons become present
            // else, the buttons are invisible
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){ // case where the user signed in
            // toggle the buttons
            signInButton.hidden = true
            statisticsButton.hidden = false
            signOutButton.hidden = false
            gamesButton.hidden = false
            settingsButton.hidden = false
            print("logged in")
            
            // assign global variables
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            userID = appDelegate.userId
            idToken = appDelegate.idToken
            fullName = appDelegate.fullName
            givenName = appDelegate.givenName
            familyName = appDelegate.familyName
            email = appDelegate.email
        }
        else { // case where the user has signed out 
            // toggle button visibility
            signInButton.hidden = false
            statisticsButton.hidden = true
            signOutButton.hidden = true
            gamesButton.hidden = true
            settingsButton.hidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    
    // [START get_user_info]
        // this function retrieves the user information from the database
            // if the user does not exist, then the function generates a new user account in the database
    func get_user_info(email: String){
        var firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        if (firebaseEmail == ""){ // this is included for testing purposes
            firebaseEmail = "kendallweihe@gmail&com"
        }
        
        ref = FIRDatabase.database().reference() // define the Firebase database reference object
        let users = self.ref.child("users") // get the users node
        users.child(firebaseEmail).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            let value = snapShot.value as! NSDictionary
            if (value["stats"] == nil){ // case where the user does not exist
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let fullName = appDelegate.fullName
                let userID = appDelegate.userId
                
                // define a new user instance
                let newUser = ["name" : fullName,
                    "stats": [
                        "userID" : userID,
                        "num_points": 0,
                        "total_num_shots": 0.0,
                        "total_num_made_shots": 0.0,
                        "shooting_percentage": 1.0,
                        "num_threes": 0,
                        "num_twos": 0
                    ],
                    "games" : [
                        "horse_score" : 0
                    ],
                    "session" : [
                        "num_points": 0,
                        "total_num_shots": 0.0,
                        "total_num_made_shots": 0.0,
                        "shooting_percentage": 1.0,
                        "num_threes": 0,
                        "num_twos": 0
                    ]
                ]
                
                let currentUser = users.child(firebaseEmail)
                currentUser.setValue(newUser) // generate a new user instance in the database
                print(currentUser)
                
                // the below code is to show how we can replace the & with a . -- a firebase constraint
                let unFirebaseEmailArray = firebaseEmail.componentsSeparatedByString("&")
                let unFirebaseEmail = unFirebaseEmailArray.joinWithSeparator(".")
                print(unFirebaseEmail) // Back to original email
            }
        })
        
        // initilialize the new session statistics to all 0
        let new_session = [
            "num_points": 0,
            "total_num_shots": 0.0,
            "total_num_made_shots": 0.0,
            "shooting_percentage": 1.0,
            "num_threes": 0,
            "num_twos": 0
        ]
        users.child(firebaseEmail).child("session").setValue(new_session) // set the new session child node
        
    }
    // [END get_user_info]

    
    // [START viewdidload]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define a GIDSignIn instance
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                                         name: "ToggleAuthUINotification",
                                                         object: nil)
        
        statusText.text = ""
        toggleAuthUI()
        print("viewDidLoad()")
        // [END_EXCLUDE]
    }
    // [END viewdidload]
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: "ToggleAuthUINotification",
                                                            object: nil)
    }
    
    // [START receiveToggleAuthUINotification]
        // this function handles incoming notifications
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") { // case where the notification is to toggle the homescreen button visibility
            self.toggleAuthUI() // toggle the homescreen button visibility
            if notification.userInfo != nil {
                let userInfo:Dictionary<String,String!> =
                    notification.userInfo as! Dictionary<String,String!>
                self.statusText.text = userInfo["statusText"]
            }
        }
    }
    // [END receiveToggleAuthUINotification]

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
