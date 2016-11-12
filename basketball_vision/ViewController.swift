//
//  ViewController.swift
//  basketball_vision
//
//  Created by Kendall Weihe on 10/16/16.
//  Copyright © 2016 Kendall Weihe. All rights reserved.
//
import UIKit
import Firebase

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    var userID = String()
    var idToken = String()
    var fullName = String()
    var givenName = String()
    var familyName = String()
    var email = String()

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var gamesButton: UIButton!
    
    
    @IBAction func tappedSignIn(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signIn()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        email = appDelegate.email
        get_user_info(email);
    }
    
    @IBAction func tappedSignOut(sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            signInButton.hidden = true
            statisticsButton.hidden = false
            signOutButton.hidden = false
            gamesButton.hidden = false
            print("logged in")
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            userID = appDelegate.userId
            idToken = appDelegate.idToken
            fullName = appDelegate.fullName
            givenName = appDelegate.givenName
            familyName = appDelegate.familyName
            email = appDelegate.email
        } else {
            signInButton.hidden = false
            statisticsButton.hidden = true
            signOutButton.hidden = true
            gamesButton.hidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    // [START define_database_reference]
    var ref: FIRDatabaseReference!
    // [END define_database_reference]
    func get_user_info(email: String){
        var firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        if (firebaseEmail == ""){
            firebaseEmail = "kendallweihe@gmail&com"
        }
        ref = FIRDatabase.database().reference()
        let users = self.ref.child("users")
        users.child(firebaseEmail).observeSingleEventOfType(.Value, withBlock : {(snapShot) in
            let value = snapShot.value as! NSDictionary
            if (value["stats"] == nil){
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let fullName = appDelegate.fullName
                let userID = appDelegate.userId
                
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
                currentUser.setValue(newUser)
                print(currentUser)
                
                let unFirebaseEmailArray = firebaseEmail.componentsSeparatedByString("&")
                let unFirebaseEmail = unFirebaseEmailArray.joinWithSeparator(".")
                print(unFirebaseEmail) // Back to original email
            }
        })
        
        let new_session = [
            "num_points": 0,
            "total_num_shots": 0.0,
            "total_num_made_shots": 0.0,
            "shooting_percentage": 1.0,
            "num_threes": 0,
            "num_twos": 0
        ]
        users.child(firebaseEmail).child("session").setValue(new_session)
        
    }
    
    // [START viewdidload]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                                         name: "ToggleAuthUINotification",
                                                         object: nil)
        
        statusText.text = "Initialized Swift app..."
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
    
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                let userInfo:Dictionary<String,String!> =
                    notification.userInfo as! Dictionary<String,String!>
                self.statusText.text = userInfo["statusText"]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
