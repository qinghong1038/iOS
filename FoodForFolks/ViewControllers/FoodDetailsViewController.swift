//
//  FoodDetailsViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class FoodDetailsViewController: UIViewController {
    
    var food:Food?
    var ref: DatabaseReference!
    var claimed = false
    
    @IBOutlet weak var claimButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodQuanty: UILabel!
    @IBOutlet weak var foodExpiration: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var foodOwner: UILabel!
    @IBOutlet weak var foodLocation: UITextView!
    @IBOutlet weak var pNumberField: UITextView!
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) 
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        ref = Database.database().reference()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let image = storageRef.child(food!.itemLocation!)
        
        image.delete { error in
            if let error = error {
                print(error)
            } else {
                HUD.flash(.success, delay: 1.0) { finished in
                    self.ref.child("food").child((self.food?.uid)!).removeValue()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    @IBAction func claimButtonClicked(_ sender: Any) {
        ref = Database.database().reference()
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("food").childByAutoId().updateChildValues(["foodTitle": foodTitle.text!, "uid": food!.postUID!, "foodQuanty": food!.itemQuanty!, "foodExp": food!.itemExpiration!, "foodDes": food!.itemDescription!, "foodOwn": food!.itemOwner!, "foodLocation": food!.itemLocation!, "phone": food!.pNum!, "company": food!.company!])
        
        ref.child("users").child(food!.postUID!).child("food").childByAutoId().updateChildValues(["foodTitle": foodTitle.text!, "uid": food!.postUID!, "foodQuanty": food!.itemQuanty!, "foodExp": food!.itemExpiration!, "foodDes": food!.itemDescription!, "foodOwn": food!.itemOwner!, "foodLocation": food!.itemLocation!, "phone": food!.pNum!, "company": food!.company!])
        ref.child("food").child((food?.uid)!).removeValue()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(food?.company)
        foodImage.image = food?.data
        foodTitle.text = food?.itemTitle
        foodQuanty.text = food?.itemQuanty
        foodExpiration.text = food?.itemExpiration
        foodDescription.text = food?.itemDescription
        foodOwner.text = food?.itemOwner
        foodLocation.text = food?.itemLocation
        pNumberField.text = "\(food!.pNum!)"
        pNumberField!.dataDetectorTypes = UIDataDetectorTypes.all;
        
        deleteButton.isEnabled = false
        claimButton.isEnabled = true
        if(Auth.auth().currentUser?.uid == food?.postUID) {
            deleteButton.isEnabled = true
            claimButton.isEnabled = false
            
        }
        if(claimed) {
            deleteButton.isEnabled = false
            claimButton.isEnabled = false
        }
        
        if(!claimed) {
            pNumberField.isHidden = true
            phoneNumLabel.isHidden = true
        }
    }
}
