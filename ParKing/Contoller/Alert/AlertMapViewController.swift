//
//  AlertMapViewController.swift
//  ParKing
//
//  Created by Mark Lai on 27/4/2022.
//

import UIKit
import GoogleMaps
//import GoogleMobileAds


//Setup Alert map view, to diplay reported alert in same day.
class AlertMapViewController: UIViewController {
    
    //Setup/Define Google map view and storyboard items.
    
    weak var mapView: GMSMapView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var BaseView: UIView!
    var currentLocation: CLLocationCoordinate2D!
    @IBOutlet var ResetButton: UIButton!
    @IBOutlet var AlertStack: UIStackView!
    @IBOutlet var AdsView: UIView!
    
    //Google Ads
//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 300, height: 50)))
//        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//
//        return adBannerView
//    }()

    // Alert List
    var alertList: [Report] = []
    
    //Current Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Setup Map
        self.setUpMap()
        
        //setup navigation bar
        if let appearance = navigationController?.navigationBar.standardAppearance {
        
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .systemOrange
            appearance.titleTextAttributes = [.font: UIFont.BlackBody, .foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = .clear
        }
        
        //Setup Google Ads
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "C9F10A5C-2632-40AD-9A61-F621E088CE98" ]
//        adBannerView.load(GADRequest())
        

        //Setup Side Menu Trigger button
        self.sideMenuBtn.target = revealViewController()
        self.sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
         
    //    self.ResetButton.setTitleColor(.white, for: .normal)
    //    self.ResetButton.tintColor = .black
    //    self.ResetButton.layer.opacity = 0.7
        self.ResetButton.titleLabel?.font = UIFont.BlackCaption1
        
        self.AdsView.layer.cornerRadius = 20
        
    }
    
    //Setup map
    func setUpMap() {
        // use Custom Style map which was created in Google map portal
        let mapId = GMSMapID(identifier: "8bdc0976207a750b")
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.42166, longitude: 114.226755, zoom: 15)
        self.mapView = GMSMapView(frame: view.bounds, mapID: mapId, camera: camera)
        self.BaseView.addSubview(self.mapView)
        self.BaseView.addSubview(self.AlertStack)
        locationManager.delegate = self
        // Load the map at set latitude/longitude and zoom level
        mapView.delegate = self
        mapView.mapType = .normal
        mapView.isTrafficEnabled = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        
        //Handle Current Location.

        // 2
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

        self.getAlert()
    }
    
    //Get Alert from Firebase
    func getAlert() {
        //Get Alert list and create marker for each of the alert. Setup Red Cirle to display on the map for each alert.
        AlertService.shared.GetAlert(){(alertList) in
            var count = 0
            for alert in alertList {
                
                //Add marker
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(alert.Lat, alert.Long)
                marker.map = self.mapView
//                marker.title = "Alert within a radius of 500 meters"
//                marker.snippet = "Time: \(alert.Date)"
                
                //Add circle in 500m radius
                let circleCenter = CLLocationCoordinate2D(latitude: alert.Lat, longitude: alert.Long)
                let circ = GMSCircle(position: circleCenter, radius: 500)
                circ.fillColor = UIColor.red.withAlphaComponent(0.2)
                circ.map = self.mapView
                
                //Setup marker icon
                let parkIcon = "320"
                let markerImage = UIImage(named: parkIcon)
                let markerView = UIImageView(image: markerImage)
                //markerView.layer.cornerRadius = 90
                markerView.layer.opacity = 0.7
                markerView.layer.cornerRadius = 50
                marker.iconView = markerView
                marker.accessibilityLabel = "\(count)"
                count = count + 1
                self.alertList.append(alert)
            }
        }

    }
    
    //Reset the map view in default setting
    @IBAction func resetCam(Sender: UIButton) {
//        self.mapView.camera = GMSCameraPosition(
//          target: self.currentLocation,
//          zoom: 14,
//          bearing: 0,
//          viewingAngle: 0)
        self.setUpMap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }
    
    @IBAction func Close (Sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindFromAlertList(segue: UIStoryboardSegue) {
    }
    

}


// MARK: - CLLocationManagerDelegate
//1
extension AlertMapViewController: CLLocationManagerDelegate {
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
      zoom: 14,
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

//Delegate of map view, to setup custom marker info window.
extension AlertMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)
        print("Marker index: \(index!)")
        let customInfoWindow = Bundle.main.loadNibNamed("MapMarkerWindowView", owner: self, options: nil)?[0] as! MapMarkerWindow
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let formatDisplay = DateFormatter()
        formatDisplay.dateFormat = "yyyy/MM/dd HH:mm"
        
        
        //Setup information to be displayed on custom info window.
        let lat = self.alertList[index!].Lat
        let long = self.alertList[index!].Long
        let Location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let reportBy = self.alertList[index!].ReportBy
        let Date = format.date(from: self.alertList[index!].Date)
        let alertTime = formatDisplay.string(from: Date!)
        customInfoWindow.ParkingName.text = "\(NSLocalizedString("By:", comment: "")) \(reportBy)"
        customInfoWindow.ParkingName.textColor = .white
        customInfoWindow.ParkingName.font = UIFont.BlackHeadLine
        customInfoWindow.ParkingVancancy.text = "\(NSLocalizedString("Time:", comment: "")) \(alertTime)"
        customInfoWindow.ParkingVancancy.textColor = .white
        customInfoWindow.ParkingVancancy.font = UIFont.NormalBody
        customInfoWindow.ParkingAddress.text = NSLocalizedString("Radius", comment: "")
        customInfoWindow.ParkingAddress.textColor = .white
        customInfoWindow.ParkingAddress.font = UIFont.NormalBody
        customInfoWindow.backgroundColor = .black
        customInfoWindow.layer.opacity = 0.7
        customInfoWindow.layer.cornerRadius = 20

        return customInfoWindow
    }
}


//extension AlertMapViewController: GADBannerViewDelegate {
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("Banner loaded successfully")
////        tableView.tableHeaderView?.frame = bannerView.frame
////        tableView.tableHeaderView = bannerView
//        self.AdsView?.frame = bannerView.frame
//        self.AdsView = bannerView
//    }
//
//    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error){
//        print("Fail to receive ads")
//        print(error)
//    }
//}
