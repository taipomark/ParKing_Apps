//
//  IndexViewController.swift
//  ParKing
//
//  Created by Mark Lai on 24/4/2022.
//

import UIKit

class IndexViewController: UITableViewController {
    
    // set up storyboard items
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var parkingLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var reportLabel: UILabel!
    @IBOutlet var parkingTitleLabel: UILabel!
    @IBOutlet var alertTitleLabel: UILabel!
    @IBOutlet var reportTitleLabel: UILabel!
    @IBOutlet var ParkingStack: UIStackView!
    @IBOutlet var AlertStack: UIStackView!
    @IBOutlet var ReportStack: UIStackView!

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
        
        // set up Side Menu Trigger Button
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        // Set up Side menu item font
        self.alertLabel.font = UIFont.NormalCaption1
        self.parkingLabel.font = UIFont.NormalCaption1
        self.reportLabel.font = UIFont.NormalCaption1
        self.parkingTitleLabel.font = UIFont.BlackHeader2
        self.alertTitleLabel.font = UIFont.BlackHeader2
        self.reportTitleLabel.font = UIFont.BlackHeader2
        
        //Set up Side Menu Item Text
        self.parkingTitleLabel.text = NSLocalizedString("Parking", comment: "")
        self.alertTitleLabel.text = NSLocalizedString("Alert", comment: "")
        self.reportTitleLabel.text = NSLocalizedString("Report", comment: "")
        self.alertLabel.text = NSLocalizedString("AlertLabel", comment: "")
        
        self.parkingLabel.text = NSLocalizedString("ParkingLabel", comment: "")
        
        self.reportLabel.text = NSLocalizedString("ReportLabel", comment: "")
        
        
//        self.AlertStack.backgroundColor = .systemGray4
//        self.ParkingStack.backgroundColor = .systemGray4
//        self.ReportStack.backgroundColor = .systemGray4
//        self.AlertStack.layer.cornerRadius = 20
//        self.ParkingStack.layer.cornerRadius = 20
//        self.ReportStack.layer.cornerRadius = 20
//        self.AlertStack.layer.opacity = 0.7
//        self.ParkingStack.layer.opacity = 0.7
//        self.ReportStack.layer.opacity = 0.7
    }
    
    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindFromProfile(segue: UIStoryboardSegue) {
    }
    
    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindFromAlertMap(segue: UIStoryboardSegue) {
    }



}
