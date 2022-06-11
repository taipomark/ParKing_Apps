//
//  ProfileTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    
    
    // set up storyboard items
    @IBOutlet var ProfileEmail: UILabel!
    @IBOutlet var ProfileName: UITextField!
    @IBOutlet var submitProfile: UIButton!
    @IBOutlet var cancelProfile: UIButton!
    @IBOutlet var ProfileNameLabel: UILabel!
    
    // get account information from google firebase
    let Email = Auth.auth().currentUser!.email!
    let Name = Auth.auth().currentUser!.displayName!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Font of Email and Account Display Name
        ProfileEmail.isEnabled = false
        ProfileEmail.text = "\(NSLocalizedString("Email:", comment: "")) \(Email)"
        ProfileEmail.tintColor = .black
        ProfileName.text = Name
        ProfileEmail.font = UIFont.BlackBody
        ProfileNameLabel.font = UIFont.BlackBody
        ProfileName.font = UIFont.NormalBody
        
        // Setup Format and Font of Submit/Cancel Button
        self.submitProfile.setTitleColor(.white, for: .normal)
        self.submitProfile.tintColor = .black
        self.submitProfile.titleLabel?.font = UIFont.BlackBody
        
        self.cancelProfile.setTitleColor(.white, for: .normal)
        self.cancelProfile.tintColor = .black
        self.cancelProfile.titleLabel?.font = UIFont.BlackBody

    }
    
    // Button Action. press submit to update account display name from google firebase
    @IBAction func UpdateProfile(Sender: UIButton) {
        
        // Save the name of the user
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = ProfileName.text
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    print("Failed to change the display name: \(error.localizedDescription)")
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }

}
