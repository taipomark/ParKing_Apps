//
//  ReportedListViewController.swift
//  ParKing
//
//  Created by Mark Lai on 19/5/2022.
//

import UIKit
import CoreLocation
import GoogleMaps

class ReportedListViewController: UIViewController {
    
    @IBOutlet var ReportList: UITableView!
    var reportedList: [Report] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getReportedList()
        
        ReportList.delegate = self
        ReportList.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func getReportedList() {
        AlertService.shared.GetReportedAlert{(reportedList) in
            //print("getAllParking: \(parkingList[0].name)")
            for reported in reportedList {
                self.reportedList.append(reported)
            }
            self.ReportList.reloadData()
        }
    }


}

extension ReportedListViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.reportedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReportedListTableViewCell.self), for: indexPath) as! ReportedListTableViewCell
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let formatDisplay = DateFormatter()
        formatDisplay.dateFormat = "yyyy/MM/dd HH:mm"
        let Date = format.date(from: self.reportedList[indexPath.row].Date)
        let alertTime = formatDisplay.string(from: Date!)
        
        
        cell.ReportedDate.text = alertTime
        cell.ReportedDate.font = UIFont.BlackBody
        cell.ReportedAddress.font = UIFont.NormalCaption1
        
        
        let Lat = reportedList[indexPath.row].Lat
        let Long = reportedList[indexPath.row].Long
        let Location = CLLocationCoordinate2D(latitude: Lat, longitude: Long)
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(Location) { response, error in
            guard let address = response?.firstResult() else {
              return
            }
            var addressString: String = ""
            if address.subLocality != nil {
                addressString = addressString + address.subLocality! + ", "
            }
            if address.thoroughfare != nil {
                addressString = addressString + address.thoroughfare! + ", "
            }
            if address.locality != nil {
                addressString = addressString + address.locality! + ", "
            }
            if address.country != nil {
                addressString = addressString + address.country! + ", "
            }
            if address.postalCode != nil {
                addressString = addressString + address.postalCode! + " "
            }
            cell.ReportedAddress.text = addressString
        }
        
        return cell

    }
    
    
    
}
