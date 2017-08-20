//
//  ViewController.swift
//  SocialNetwork
//
//  Created by COMPUTER on 7/24/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
   
    @IBOutlet weak var errorField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   FBSDKSettings.setAppID("SocialNetwork")
        
            }
    
    override func viewDidAppear(_ animated: Bool) {
        //this segue isn't necessary right here; it is in that function at bottom but I might as well keep it here because I might need it for the facebook login
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            //above ^^ checking if key exists
           performSegue(withIdentifier: "goToFeed", sender: nil)
            print("ELI: ID found in keychain")
        }
         


    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("ELI: Unable to authenticate with Facebook - \(String(describing: error))")
 
            } else if result?.isCancelled == true {
                print("ELI: User cancelled Facebook authentication")
            }
    
            else {
                print("ELI: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    
    
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("ELI: Succesfully authenticated with Firebase")
                
                if let user = user{
                    
                    let userData = ["provider": credential.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
    
        if let email = emailField.text, let pwd = pwdField.text {
            //IN OWN APPS PUT NOTIFICATION TO USER
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("ELI: User email authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                
                
                
                } else {
                    //this is error handling if user doesn't exist, or incorrect info. 
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        
                        if error != nil {
                            //this is if an error
                            
                            
                            guard let error = AuthErrorCode(rawValue: (error?._code)!) else {
                                return
                            }

                            
                            func fireErrorHandle(code: AuthErrorCode) {
                                switch code {
                                case .invalidCustomToken:
                                    print("Indicates a validation error with the custom token")
                                case .customTokenMismatch:
                                    print("Indicates the service account and the API key belong to different projects")
                                case .invalidCredential:
                                    print("Indicates the IDP token or requestUri is invalid")
                                case .userDisabled:
                                    print("Indicates the user's account is disabled on the server")
                                case .wrongPassword:
                                    print("ELI: Indicates the user attempted sign in with a wrong password")
                                case .invalidEmail:
                                    print("ELI: INVALID EMAIL")
                                case .weakPassword:
                                    print("ELI: WEAK PASSWORD")
                                
                                default:
                                    print("Indicates an internal error occurred")
                                }
                            }
                            fireErrorHandle(code: error)

                            
                        } else {
                            print("ELI: Succesfully authenticated with Firebase")
                            if let user = user {
                                
                                let userData = ["provider": user.providerID]
                                //we are using this user data constant as a way to reference the name and value part of our database called "Provider" and the value is either Firebase, or Facebook.com
                                
                                
                                self.completeSignIn(id: user.uid, userData: userData)
                            
                            }
                           
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
      let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ELI: Data saved to keychain \(keychainResult)")
        //user.uid is just the id of user
        //KEY_UID is just so we avoid a typo when we use this string more
   performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
    

}

