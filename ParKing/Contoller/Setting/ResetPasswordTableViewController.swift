//
//  ResetPasswordTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 14/5/2022.
//

import UIKit
import Firebase

//Setup Password reset view
class ResetPasswordTableViewController: UITableViewController {
    
    //Define Storyboard items
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var submitButton: UIButton!

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

        //Setup Textfield font
        self.emailTextField.font = UIFont.NormalBody
        
        //Setup button style and font
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.tintColor = .black
        self.submitButton.layer.opacity = 0.7
        self.submitButton.titleLabel?.font = UIFont.BlackBody
        
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.cancelButton.tintColor = .black
        self.cancelButton.layer.opacity = 0.7
        self.cancelButton.titleLabel?.font = UIFont.BlackBody
    }

    //Action for reset password, new password will be sent to registered valid email
    @IBAction func resetPassword(sender: UIButton) {
        
        // Validate the input
        guard let emailAddress = emailTextField.text,
            emailAddress != "" else {
                
                let alertController = UIAlertController(title: NSLocalizedString("InputError", comment: ""), message: NSLocalizedString("ProvideEmail", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        // Send password reset email
        Auth.auth().sendPasswordReset(withEmail: emailAddress, completion: { (error) in
            
            let title = (error == nil) ? NSLocalizedString("ResetFollow", comment: "") : NSLocalizedString("ResetError", comment: "")
            let message = (error == nil) ? NSLocalizedString("ResetEmail", comment: "") : error?.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                
                if error == nil {
                    
                    // Dismiss keyboard
                    self.view.endEditing(true)

                    // Return to the login screen
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okayAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        })
        
    }

}
