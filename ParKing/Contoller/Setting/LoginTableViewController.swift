//
//  LoginTableViewController.swift
//  ParKing
//
//  Created by Mark Lai on 1/5/2022.
//

import UIKit
import Firebase
import GoogleSignIn
import LocalAuthentication

//Setup for Apps login service (By Email)
class LoginTableViewController: UITableViewController {
    
    //Define Storyboard items
    @IBOutlet var LoginEmail: UITextField!
    @IBOutlet var LoginPassword: UITextField!
    @IBOutlet var ForgetPassword: UIButton!
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
        
        //setup Button and label font/style
        self.LoginEmail.font = UIFont.NormalBody
        self.LoginPassword.font = UIFont.NormalBody

        self.submitButton.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.tintColor = .black
     //   self.submitButton.layer.opacity = 0.7
        self.submitButton.titleLabel?.font = UIFont.BlackHeadLine
    
        self.cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.cancelButton.tintColor = .black
      //  self.cancelButton.layer.opacity = 0.7
        self.cancelButton.titleLabel?.font = UIFont.BlackHeadLine
        
        self.ForgetPassword.setTitle(NSLocalizedString("ForgetPassword", comment: ""), for: .normal)
        self.ForgetPassword.titleLabel?.font = UIFont.BlackBody
        
     //   self.view.isHidden = true
        authenticateWithBiometric()

    }
    
    func authenticateWithBiometric() {
        // 取得本地端授權內容
        let localAuthContext = LAContext()
        let reasonText = "Authentication is required to sign in AppCoda"
        var authError: NSError?
        let SavedEmail = self.RetrivePassword(for: "Email") ?? ""
        let SavedPassword = self.RetrivePassword(for: "Password") ?? ""
        
        if SavedEmail == "", SavedPassword == "" {
       //     self.view.isHidden = false
            print("Not Enrolled yet")
            return
        }

        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {

            if let error = authError {
                print(error.localizedDescription)
            }

            // 當 Touch ID 無法取得(例如在模擬器中使用)，則呈現登入對話框
      //      self.view.isHidden = false
            print("No touch ID")

            return
        }
        
    
        
        // Perform the Touch ID authentication
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText, reply: { (success: Bool, error: Error?) -> Void in
            
            // Failure workflow
            if !success {
                if let error = error {
                    switch error {
                    case LAError.authenticationFailed:
                        print("Authentication failed")
                    case LAError.passcodeNotSet:
                        print("Passcode not set")
                    case LAError.systemCancel:
                        print("Authentication was canceled by system")
                    case LAError.userCancel:
                        print("Authentication was canceled by the user")
                    case LAError.biometryNotEnrolled:
                        print("Authentication could not start because you haven't enrolled either Touch ID or Face ID on your device.")
                    case LAError.biometryNotAvailable:
                        print("Authentication could not start because Touch ID / Face ID is not available.")
                    case LAError.userFallback:
                        print("User tapped the fallback button (Enter Password).")
                    default:
                        print(error.localizedDescription)
                    }
                }
                
            } else {
            
                // Success workflow
                
                print("Successfully authenticated")
                OperationQueue.main.addOperation({
                    self.FirebaseLogin(emailAddress: SavedEmail, password: SavedPassword)
                    
                })
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //handle login submit, to trigger firebase function for authentication
    @IBAction func LoginSubmit(Sender: UIButton){
        
        // Validate the input
        guard let emailAddress = LoginEmail.text, emailAddress != "",
            let password = LoginPassword.text, password != "" else {
                
                let alertController = UIAlertController(title: NSLocalizedString("LoginError", comment: ""), message: NSLocalizedString("BothNotBlank", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        self.FirebaseLogin(emailAddress: emailAddress, password: password)
        
    
    }
    
    func FirebaseLogin (emailAddress: String, password: String) {
        // Perform login by calling Firebase APIs
        Auth.auth().signIn(withEmail: emailAddress, password: password, completion: { (result, error) in
//            let loadingView = LoadingView(frame: CGRect(x: self.view.frame.midX - 40, y: self.view.frame.midY - 100, width: 60, height: 60))
//            loadingView.startLoading()
//            self.view.addSubview(loadingView)
            
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("LoginError", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            // Email verification
            guard let result = result, result.user.isEmailVerified else {
                let alertController = UIAlertController(title: NSLocalizedString("LoginError", comment: ""), message: NSLocalizedString("ConfirmEmail", comment: ""), preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: NSLocalizedString("ResendEmail", comment: ""), style: .default, handler: { (action) in
                    
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                })
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            UserDefaults.standard.set(String(describing: Auth.auth().currentUser?.displayName!), forKey: "username")
            UserDefaults.standard.synchronize() //needs restrat
            
            // Dismiss keyboard
            self.view.endEditing(true)
            
            self.PasswordSave(password, for: "Password")
            self.PasswordSave(emailAddress, for: "Email")
            
            let storyboard = UIStoryboard(name: "Index", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainContainerViewController")
              
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
         //   loadingView.removeFromSuperview()
        })
    }
    
    func PasswordSave(_ password: String, for account: String) {
            let password = password.data(using: String.Encoding.utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: account,
                                        kSecValueData as String: password]
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                return print("save error")
            }
    }
        
    func RetrivePassword(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
}
