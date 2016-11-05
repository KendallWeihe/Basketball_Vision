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
            print("here")
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
