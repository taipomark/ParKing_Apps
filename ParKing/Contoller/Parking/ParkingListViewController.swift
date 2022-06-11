//
//  ParkingListViewController.swift
//  ParKing
//
//  Created by Mark Lai on 5/5/2022.
//

import UIKit

//setup table view to display parking in list view
class ParkingListViewController: UIViewController {
    
    var InputParkingList: [ParkingDBInfo]!
    var FilterList: [ParkingDBInfo]!
    var Vacancy: [ParkingVacancy]!
    var Row: Int = 0
    @IBOutlet var parkingTable: UITableView!
    @IBOutlet var parkingScroll: UIView!
    
    //Header button for user to filter by district of Hong Kong
    var district:[ String] = [NSLocalizedString("All", comment: ""),NSLocalizedString("Islands", comment: ""),NSLocalizedString("Kwai Tsing", comment: ""),NSLocalizedString("North", comment: ""),NSLocalizedString("Sai Kung", comment: ""),NSLocalizedString("Sha Tin", comment: ""),NSLocalizedString("Tai Po", comment: ""),NSLocalizedString("Tsuen Wan", comment: ""),NSLocalizedString("Tuen Mun", comment: ""),NSLocalizedString("Yuen Long", comment: ""),NSLocalizedString("Kowloon City", comment: ""),NSLocalizedString("Kwun Tong", comment: ""),NSLocalizedString("Sham Shui Po", comment: ""),NSLocalizedString("Wong Tai Sin", comment: ""),NSLocalizedString("Yau Tsim Mong", comment: ""),NSLocalizedString("Central and Western", comment: ""),NSLocalizedString("Eastern", comment: ""),NSLocalizedString("Southern", comment: ""),NSLocalizedString("Wan Chai", comment: "")]

    override func viewDidLoad() {
        super.viewDidLoad()
        parkingTable.delegate = self
        parkingTable.dataSource = self
        
        //setup navigation bar
        if let appearance = navigationController?.navigationBar.standardAppearance {
        
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .systemOrange
            appearance.titleTextAttributes = [.font: UIFont.BlackBody, .foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        
        self.FilterList = self.InputParkingList
        
        
        //Setup header button view
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .leading
        buttonStack.spacing = 10
        buttonStack.frame = CGRect(x: 10, y: 0, width: 4000, height: 30)
        parkingScroll.addSubview(buttonStack)
        
        
        //Setup filtering
        for col in 0...18 {
            let button = UIButton()
            button.frame = CGRect(x: (col * 50) + 10, y: 0, width: 50, height: 30)
            button.layer.cornerRadius = 10
            button.backgroundColor = .gray
            button.setTitle("\(district[col])", for: .normal)
            button.tag = col
            button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
     //       button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                        
            // add button to row stack view
            buttonStack.addArrangedSubview(button)
                        
            // buttons should be 50x50
            NSLayoutConstraint.activate([
         //       button.widthAnchor.constraint(equalToConstant: 50.0),
          //      button.heightAnchor.constraint(equalToConstant: 50.0),
                buttonStack.topAnchor.constraint(equalTo: parkingScroll.topAnchor, constant: 0.0),
                parkingScroll.leadingAnchor.constraint(equalTo: parkingScroll.leadingAnchor, constant: 10.0),
                parkingScroll.trailingAnchor.constraint(equalTo: parkingScroll.trailingAnchor, constant: 10.0),
                parkingScroll.bottomAnchor.constraint(equalTo: parkingScroll.bottomAnchor, constant: 0.0),
            ])
                        
        }
    }
    
    //Filter the list
    @objc func pressed(sender: UIButton) {
        print("pressed: \(sender.tag)")
        if sender.tag == 0 {
            self.FilterList = self.InputParkingList
            self.parkingTable.reloadData()
        }
        else {
            self.FilterList = self.InputParkingList.filter({$0.district.contains(district[sender.tag])})
            self.parkingTable.reloadData()
        }
        
    }

}

extension ParkingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterList.count
    }
    
    //Setup Parking information table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ParkingTableViewCell.self), for: indexPath) as! ParkingTableViewCell
        cell.ParkingName.text = FilterList[indexPath.row].name
        cell.ParkingDistrict.text = FilterList[indexPath.row].district
  //      cell.ParkingAddress.text = FilterList[indexPath.row].displayAddress
        let parkID = FilterList[indexPath.row].postId
        let vacancyObj = self.Vacancy.filter({$0.parkingID == parkID})
        let vacancy = vacancyObj.first?.Vacancy
        let vacancyType = vacancyObj.first?.vacancyType
        cell.ParkingVancancy.text = "\(NSLocalizedString("Vacancy", comment: "")) \(String(describing: vacancy ?? 0))"
        
        if vacancy ?? 0 == -1 {
            cell.ParkingVancancy.text = NSLocalizedString("VacancyNA", comment: "")
            cell.ParkingVancancyImage.image = UIImage(named: "blueP")
        } else if vacancy ?? 0 == 1{
            if vacancyType ?? "B" == "B" {
                cell.ParkingVancancyImage.image = UIImage(named: "greenP")
                cell.ParkingVancancy.text = NSLocalizedString("VacancyOK", comment: "")
            } else {
                cell.ParkingVancancyImage.image = UIImage(named: "yellowP")
            }
        } else if vacancy ?? 0 == 0{
            cell.ParkingVancancyImage.image = UIImage(named: "redP")
        } else if vacancy ?? 0 < 30 {
            cell.ParkingVancancyImage.image = UIImage(named: "yellowP")
        } else {
            cell.ParkingVancancyImage.image = UIImage(named: "greenP")
        }
        
        cell.ParkingName.font = UIFont.BlackHeadLine
        cell.ParkingDistrict.font = UIFont.NormalCaption1
        cell.ParkingVancancy.font = UIFont.NormalCaption1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Row = indexPath.row
        performSegue(withIdentifier: "UnwindParkingRow", sender: self)
    }
    
    
}

