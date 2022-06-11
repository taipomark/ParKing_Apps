//
//  SideMenuViewController.swift
//  ParKing
//
//  Created by Mark Lai on 30/4/2022.
//

import UIKit

// Setup Side Menu
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet var headerTitle: UILabel!
    @IBOutlet var sideMenuTableView: UITableView!

    var defaultHighlightedCell: Int = 0

    // Setup Side Menu Icon
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "bell.fill")!, title: NSLocalizedString("Alert", comment: "")),
        SideMenuModel(icon: UIImage(systemName: "p.square.fill")!, title: NSLocalizedString("Parking", comment: "")),
        SideMenuModel(icon: UIImage(systemName: "list.bullet.rectangle")!, title: NSLocalizedString("Report", comment: "")),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: NSLocalizedString("Setting", comment: "")),
        SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: NSLocalizedString("About", comment: "")),
        SideMenuModel(icon: UIImage(systemName: "power")!, title: NSLocalizedString("Signout", comment: ""))
    ]
    
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerTitle.font = UIFont.BlackHeader
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = .systemGray6
        self.sideMenuTableView.separatorStyle = .none

        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    // Setup Side Menu Table Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        cell.titleLabel.font = UIFont.BlackHeadLine
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = .orange
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(indexPath.row)
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
//        if indexPath.row == 4 || indexPath.row == 6 {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
}
