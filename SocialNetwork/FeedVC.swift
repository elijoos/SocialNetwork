//
//  FeedVC.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/5/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
       tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
    //1. Sign out of firebase in here
    //2. Remove our ID from Keychain
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ELI: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignInVC", sender: nil)
        
   
    }
    
    
    
   
    
    
}
