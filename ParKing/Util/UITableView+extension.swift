//
//  UITableView+extension.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import Foundation
import UIKit

//Hide keyboard when not use
extension UITableViewController {
    func tableHideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboardTable))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardTable() {
        view.endEditing(true)
    }
}
