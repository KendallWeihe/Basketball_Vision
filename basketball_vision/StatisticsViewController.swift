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

        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            GIDSignIn.sharedInstance().signInSilently()
        }
        
        ref = FIRDatabase.database().reference()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let email = appDelegate.email // email from delegate
        let firebaseEmail = email.stringByReplacingOccurrencesOfString(".", withString: "&") // makes the email valid for Firebase
        
        let fullName = appDelegate.fullName
        let userID = appDelegate.userId
        
        let newUser = ["name" : fullName,
                       "userID" : userID]
        
        let users = self.ref.child("users")
        let currentUser = users.child(firebaseEmail)
        currentUser.setValue(newUser)
        print(currentUser)
        
        let unFirebaseEmailArray = firebaseEmail.componentsSeparatedByString("&")
        let unFirebaseEmail = unFirebaseEmailArray.joinWithSeparator(".")
        print(unFirebaseEmail) // Back to original email
        
        
//        let ref = FIRDatabase.database().reference()
//        let users = ref.child("users")
//        //let currentUser = users.childByAppendingPath(FIRAuth.auth()!.currentUser!.email!)
//        let currentUser = users.childByAppendingPath("\(email)")
//        print(currentUser)
        
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
