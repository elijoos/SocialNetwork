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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageAdd: CircleView!
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache<NSString, UIImage>()
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
       tableView.dataSource = self
    
       imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        //allows the user to edit the photo after taking it, like cropping it on instagram
       imagePicker.delegate = self
    
        
        //this is the observer/listener
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value!)
        //PARCING FIREBASE DATA
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            
        } else {
            print("ELI: A valid image wasn't selected")
        }
        //All this function does is: Once we select an image, dismiss the image Picker...Thats it
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
    
    //new stuff from youtube below
        
    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("camera not available")
            }
    }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
       actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    present(actionSheet, animated: true, completion: nil)
    
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let post = posts[indexPath.row]
        //we grab our posts
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
        
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
           
            
        } else {
            
            return PostCell()
        }
        
        
        
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
