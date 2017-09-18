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
    
    @IBOutlet weak var captionField: FancyField!
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache<NSString, UIImage>()
   
    var imageSelected = false
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableView.delegate = self
       tableView.dataSource = self
        
       tableView.rowHeight = 448
        
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
            
            imageSelected = true
            
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
                //Here we go into our imageCache, find our image which has the location at forKey (the image url) and set that = to img
                cell.configureCell(post: post, img: img)
                
                
                
            } else {
                cell.configureCell(post: post)
                
            }
            return cell
           
            
        } else {
            
            return PostCell()
        }
        
        
        
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
    //Post to firebase
    
        guard let caption = captionField.text, caption != "" else {
            //In here maybe highlight the box to show user they need to enter caption
            captionField.isHighlighted = true
            
            print("ELI: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("ELI: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
        //converting our image into image data, which will be used to be passed up to firebase storage; Doing it as a jpeg and COMPRESSING IT (which will save storage)
            let imgUid = NSUUID().uuidString
            //basically a random identifier for each object
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            //just specifies the type
   
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata, completion: { (metadata, error) in
              
                //the metadata in the completion handler will contain the URL (they call it downloadUrl). We get it as an ABSOLUTESTRING ("the raw string")
                if error != nil {
                    print("ELI: Unable to upload image to Firebase storage")
                } else {
                    print("ELI: Successfully uploaded image to Firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    //just string for url
                    
                 self.postToFirebase(imgUrl: downloadUrl!)
                
                }
            })
        }
    }
    
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject,
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        //we could do updateChildValues but we just can use setValue because since this is a brand new post there's not going to be existing data in it
        tableView.reloadData()
        
        self.captionField.text = ""
        self.imageSelected = false
        self.imageAdd.image = UIImage(named: "add-image")
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
    //1. Sign out of firebase in here
    //2. Remove our ID from Keychain
        
        let signOutActionSheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        
        signOutActionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            print("ELI: ID removed from keychain \(keychainResult)")
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "goToSignInVC", sender: nil)
        }))
        
        signOutActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(signOutActionSheet, animated: true, completion: nil)
    }
    
    
    
   
    
    
}
