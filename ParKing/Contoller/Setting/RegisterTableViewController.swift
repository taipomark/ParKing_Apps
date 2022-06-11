//
//  RegisterTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 14/5/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

//Setup Account Register View
class RegisterTableViewController: UITableViewController {
    
    //Define Storyboard items
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userPassword: UITextField!
    @IBOutlet var userConfirmPassword: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup navigation bar
        if let appearance = navigationController?.navigationBar.standardAppearance {
        
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .systemOrange
            appearance.titleTextAttributes = [.font: UIFont.BlackBody, .foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //Setup label font
        self.userEmail.font = UIFont.NormalBody
        self.userName.font = UIFont.NormalBody
        self.userPassword.font = UIFont.NormalBody
        self.userConfirmPassword.font = UIFont.NormalBody
        
        //Setup Button style and font
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.tintColor = .black
        self.submitButton.layer.opacity = 0.7
        self.submitButton.titleLabel?.font = UIFont.BlackBody
        
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.cancelButton.tintColor = .black
        self.cancelButton.layer.opacity = 0.7
        self.cancelButton.titleLabel?.font = UIFont.BlackBody
        
    }

    //Action for registering new account
    @IBAction func registerAccount(sender: UIButton) {
        
        // Validate the input
        guard let name = userName.text, name != "",
            let emailAddress = userEmail.text, emailAddress != "",
            let password = userPassword.text, password != "" else {
                
                let alertController = UIAlertController(title: NSLocalizedString("RegisterError", comment: ""), message: NSLocalizedString("RegisterNotProvide", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Validate the input
        guard userPassword.text == userConfirmPassword.text else {
                
                let alertController = UIAlertController(title: NSLocalizedString("PasswordError", comment: ""), message: NSLocalizedString("PasswordNotSame", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Register the user account on Firebase
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { (result, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("RegisterError", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Save the name of the user
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            // Dismiss keyboard
            self.view.endEditing(true)
            
            // Send verification email
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("Failed to send verification email")
            })
            
            do {
                try Auth.auth().signOut()
            }
            catch{
                let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            let alertController = UIAlertController(title: NSLocalizedString("EmailVerification", comment: ""), message: NSLocalizedString("VerificationSend", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                // Dismiss the current view controller
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            
        })
        
        
        
    }

}
