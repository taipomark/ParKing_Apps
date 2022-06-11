//
//  WelcomeTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 1/5/2022.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = Auth.auth().currentUser?.displayName!
        // if user is logged in before
        //Controling login scene
        if username != nil {
            // instantiate the main tab bar controller and set it as root view controller
            // using the storyboard identifier we set earlier
            let storyboard = UIStoryboard(name: "Index", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainContainerViewController")
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }

    }

    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindToWelceom(segue: UIStoryboardSegue) {
    }
    
    //Action for Google sign in
    @IBAction func GoogleSignIn(sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else { return }
     
            // If sign in succeeded, display the app's main content View.
            // Dismiss keyboard
            self.view.endEditing(true)
            
            let user = GIDSignIn.sharedInstance.currentUser
            guard let authentication = user?.authentication else {
                print("GIDSignIn Failed")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)

                    return
                }
                
                let storyboard = UIStoryboard(name: "Index", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainContainerViewController")
                  
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
          
            
        }
    }
    
}
