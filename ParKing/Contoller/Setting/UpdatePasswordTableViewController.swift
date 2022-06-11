//
//  UpdatePasswordTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 4/6/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdatePasswordTableViewController: UITableViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var ReEnterPassword: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var resetButton: UIButton!

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
        
        self.cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.cancelButton.tintColor = .black
     //   self.submitButton.layer.opacity = 0.7
        self.cancelButton.titleLabel?.font = UIFont.BlackHeadLine
    
        self.resetButton.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
        self.resetButton.setTitleColor(.white, for: .normal)
        self.resetButton.tintColor = .black
      //  self.cancelButton.layer.opacity = 0.7
        self.resetButton.titleLabel?.font = UIFont.BlackHeadLine
        
    }
    
    @IBAction func UpdatePasswordSubmit(Sender:UIButton){
        
        let password = self.password.text!
        let ReEnterPassword = self.ReEnterPassword.text!
        
        guard password != "", ReEnterPassword != "",
              password == ReEnterPassword else {
            print("Reset Password Input Error")
            self.ResetAlert()
            return
        }
        
        
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            self.ResetAlertOK()
        }
    }
    
    func ResetAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("ResetError", comment: ""), message: NSLocalizedString("BothNotBlank", comment: ""), preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
        
        return
    }
    
    
    func ResetAlertOK() {
        let alertController = UIAlertController(title: NSLocalizedString("ResetOK", comment: ""), message: NSLocalizedString("ResetOKDesc", comment: ""), preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
        
        
        return
    }

}
