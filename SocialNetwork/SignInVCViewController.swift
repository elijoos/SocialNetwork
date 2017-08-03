//
//  SignInVCViewController.swift
//  SocialNetwork
//
//  Created by COMPUTER on 7/29/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit

class SignInVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        //time to call a method below
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("ELI: user cancelled Facebook authentification")
                //This is if when we ask for user permition that they click "cancel" button on that notification
            } else {
                print("ELI: Succesfully authentificated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
        
    }
    
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Firebase - \(error)")
            } else {
                print("ELI: Succesfully authenticated with Firebase")
            }
        }
    }
    
    
    
    
    
    
}


}
