//
//  SettingViewController.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import UIKit
import Firebase

//Setup setting page. Display account information. Setup 3 buttons for editing user profile, apps setting and review reported history.
class SettingViewController: UIViewController {
    //Setup/Define Storyboard items. And get firebase account information.
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var Email: UILabel!
    @IBOutlet var Name: UILabel!
    let userEmail = Auth.auth().currentUser!.email!
    let userName = Auth.auth().currentUser!.displayName!
    
    @IBOutlet var ProfileButton: UIButton!
    @IBOutlet var SettingButton: UIButton!
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var UpdatePasswordButton: UIButton!

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
        
        //Setup side menu trigger button
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        //Setup Account information and display on the screen
        Email.text = userEmail
        Name.text = userName
        Name.font = UIFont.BlackHeader2
        Email.font = UIFont.BlackHeadLine
        
        //Setup button font
        self.ProfileButton.titleLabel?.font = UIFont.BlackBody
        self.SettingButton.titleLabel?.font = UIFont.BlackBody
        self.RecordButton.titleLabel?.font = UIFont.BlackBody
        self.UpdatePasswordButton.titleLabel?.font = UIFont.BlackBody

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
        //Setup button font
        self.ProfileButton.titleLabel?.font = UIFont.BlackBody
        self.SettingButton.titleLabel?.font = UIFont.BlackBody
        self.RecordButton.titleLabel?.font = UIFont.BlackBody
        self.UpdatePasswordButton.titleLabel?.font = UIFont.BlackBody
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }

    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindToSetting(segue: UIStoryboardSegue) {
    }
    
    //Redirect to IOS Apps setting page.
    @IBAction func AppsSetting(Sender: UIButton){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }

}
