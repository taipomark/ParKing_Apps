//
//  ReportViewController.swift
//  ParKing
//
//  Created by Mark Lai on 1/5/2022.
//

import UIKit
import GoogleMaps
import Firebase

// Setup Report Alert Map View
class ReportViewController: UIViewController {
    
    // Define Google Map View
    weak var mapView: GMSMapView!

    // Define Storyboard items
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var currentButton: UIButton!
    @IBOutlet var reportAddr: UILabel!
    @IBOutlet var BaseView: UIView!
    @IBOutlet var FormView: UIView!
    @IBOutlet var FormStack: UIStackView!

    // Setup variable for GPS Location
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    var selectedLocation: CLLocationCoordinate2D!
    var reportOption: Int = 1

    
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
        
        //Setup Header View
        self.FormView.backgroundColor = .systemOrange
        self.view.backgroundColor = .systemOrange
        self.reportAddr.font = UIFont.BlackBody
        self.reportAddr.textColor = .black

        //Setup Side Menu Trigger Button
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        self.setUpMap()
        
        //Setup font for submit and current location button
        self.submitButton.titleLabel?.font = UIFont.BlackCaption1
    //    self.submitButton.setTitleColor(.white, for: .normal)
     //   self.submitButton.tintColor = .black
    //    self.submitButton.layer.opacity = 0.7
        
        self.currentButton.titleLabel?.font = UIFont.BlackCaption1
    //    self.currentButton.setTitleColor(.white, for: .normal)
    //    self.currentButton.tintColor = .black
    //    self.currentButton.layer.opacity = 0.7
        
    }
    
    // Setup Map with Custom Style which was created in Google Map Portal
    func setUpMap() {
        // 1
        let mapId = GMSMapID(identifier: "8bdc0976207a750b")
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.42166, longitude: 114.226755, zoom: 15)
        self.mapView = GMSMapView(frame: view.bounds, mapID: mapId, camera: camera)
        self.BaseView.addSubview(self.mapView)
        self.BaseView.addSubview(self.FormStack)
        locationManager.delegate = self
        // Load the map at set latitude/longitude and zoom level
        mapView.delegate = self
        mapView.mapType = .normal
        mapView.isTrafficEnabled = true
        
     //   self.view = mapView

        // Get GPS Location
        if CLLocationManager.locationServicesEnabled() {
            // 3
            locationManager.requestLocation()

            // 4
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            
        } else {
            // 5
            locationManager.requestWhenInUseAuthorization()
        }
        self.currentLocation = locationManager.location?.coordinate

        //Setup marker at current location for reporting purpose. User could click on the map to custom location for reporting alert.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.currentLocation.latitude, self.currentLocation.longitude)
        marker.map = mapView
        marker.title = NSLocalizedString("ReportLocation", comment: "")
        marker.snippet = ""
        
        self.displayCurrentAddr()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }
    
    // Default display Current Location Address.
    // When user manual select location on the map, display address of selected location.
    func displayCurrentAddr() {
        
        var reportLocation: CLLocationCoordinate2D!
        if self.reportOption == 1 {
            reportLocation = self.currentLocation
        } else {
            reportLocation = self.selectedLocation
        }
        
        // Decode GPS location into readable address.
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(reportLocation) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
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
            self.reportAddr.text = addressString
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(reportLocation.latitude, reportLocation.longitude)
            marker.map = self.mapView
            marker.title = NSLocalizedString("ReportLocation", comment: "")
            marker.snippet = ""
            
        }
    }
    
    //Setup and Display address of current location.
    @IBAction func currentAddr(Sender: UIButton) {
        self.reportOption = 1
        self.mapView.clear()
        self.displayCurrentAddr()
    }
    
    //Setup and Display address of manual selected location.
    @IBAction func submitManual(Sender: UIButton) {
        var reportLocation: CLLocationCoordinate2D!
        if self.reportOption == 1 {
            reportLocation = self.currentLocation
        } else {
            reportLocation = self.selectedLocation
        }
        
        //Decode Location into Readable Addess
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(reportLocation) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
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
            self.reportAddr.text = addressString
            
            // Get User Account information to insert reported record into
         //   let alertAddress = lines.joined(separator: "\n")
            
            let User = Auth.auth().currentUser!.displayName ??  Auth.auth().currentUser!.email
            let UserId = Auth.auth().currentUser!.uid
            //prepare uploading task
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyyMMddHHmmss"
            let createDate = format.string(from: date)
            let reportLat = Double(round(500 * reportLocation.latitude) / 500)
            let reportLong = Double(round(500 * reportLocation.longitude) / 500)
            
            let AlertData: [String: Any] = ["ReportBy": User ?? "Anonymous",
                                            "ReportByUserID": UserId,
                                            "Date": createDate,
                                            "Lat": reportLat,
                                            "Long": reportLong,
                                            "Status": "A"]
            // Call Alert Service to add new alert into DB
            AlertService.shared.AddNewAlert(alertData: AlertData){
                
                
                let alertController = UIAlertController(title: NSLocalizedString("ReportAlert", comment: ""), message: NSLocalizedString("ReportSuccess", comment: ""), preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                self.submitButton.isEnabled = false
                
            }
            
        }
    }

}


// MARK: - CLLocationManagerDelegate
//1
extension ReportViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.requestLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
        
    // 7
    mapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
        
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
}


// Delegate of map view. Add Tap action handler
extension ReportViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.reportOption = 2
        self.selectedLocation = coordinate
        self.displayCurrentAddr()
    }
}
