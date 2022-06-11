//
//  ParkingViewController.swift
//  ParKing
//
//  Created by Mark Lai on 1/5/2022.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import MapKit

//Setup Parking information map view. To display all parking site from hk and set custom markers on the map view.
class ParkingViewController: UIViewController {
    
    //Setup/Define Google map view and storyboard items
   // @IBOutlet private weak var mapView: GMSMapView!
    weak var mapView: GMSMapView!
    @IBOutlet var BaseView: UIView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var NavButton: UIButton!
    @IBOutlet var ResetButton: UIButton!
    @IBOutlet var ListButton: UIButton!
    @IBOutlet var BottomView: UIView!
    @IBOutlet var BottomDistance: UILabel!
    @IBOutlet var BottomDuration: UILabel!
    @IBOutlet var buttonStack: UIStackView!
    @IBOutlet var ButtonList: UIButton!

    
    //Setup parameters
    var styleMapView: GMSMapView!
    var isNav = true
    var apiDistance: Int! = 0
    var apiDuration: Int! = 0
    var apiZoom: Float! = 0
    
    //Setup parking list and vacancy list
    var parkList: [ParkingDBInfo] = []
    var originalList: [ParkingDBInfo] = []
    var parkingVacancy: [ParkingVacancy] = []
    var currentLocation: CLLocationCoordinate2D!
    var DestinationLocation: CLLocationCoordinate2D!
    
    //Setup current location parameter
    let locationManager = CLLocationManager()
    var isLocationEnable = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup map and get all Vacancy and parking information
        setUpMap()
        getAllVancancy()
        
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
         
        //Setup functional buttons on the map.
        NavButton.isEnabled = false
      //  NavButton.setTitleColor(.white , for: .normal)
        self.NavButton.titleLabel?.font = UIFont.BlackCaption1
        self.ResetButton.titleLabel?.font = UIFont.BlackCaption1
        self.ListButton.titleLabel?.font = UIFont.BlackCaption1
        
        self.BottomDistance.text = ""
        self.BottomDuration.text = ""
        self.BottomView.backgroundColor = .clear
        self.BottomView.layer.cornerRadius = 10
        
        self.ButtonList.isEnabled = false
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(22.42166, 114.226755)
//        marker.map = mapView
//        marker.title = "Ma On Shan"
//        marker.snippet = "Parking Test"
        
        
    }
    
    //When user trigger reset action, reload the map in default setting.
    @IBAction func reload(Sender: UIButton) {
        self.mapView.clear()
        self.setUpMap()
        self.getAllParking()
        self.getAllVancancy()
        NavButton.isEnabled = false
        self.BottomDistance.text = ""
        self.BottomDuration.text = ""
        self.BottomView.backgroundColor = .clear
        self.BottomView.layer.cornerRadius = 10
    }
    
    //Setup the map
    func setUpMap() {
        // Setup map view with custom style which was created in google map portal
        let mapId = GMSMapID(identifier: "8bdc0976207a750b")
        let camera:GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.42166, longitude: 114.226755, zoom: 15)
        self.mapView = GMSMapView(frame: view.bounds, mapID: mapId, camera: camera)
        self.BaseView.addSubview(self.mapView)
        self.BaseView.addSubview(self.buttonStack)
        locationManager.delegate = self
        // Load the map at set latitude/longitude and zoom level
        mapView.delegate = self
        mapView.mapType = .normal
        mapView.isTrafficEnabled = true
        
     //   self.view = mapView

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

    }
    
    //Get all vacancy from Government Open API
    func getAllVancancy() {
        let langStr = Locale.current.languageCode!
        print("Parking Language = \(String(describing: langStr))")
        var url: String!
        if langStr == "en" {
            url = "https://api.data.gov.hk/v1/carpark-info-vacancy?data=vacancy&vehicleTypes=privateCar&lang=en_US"
        }
        else {
            url = "https://api.data.gov.hk/v1/carpark-info-vacancy?data=vacancy&vehicleTypes=privateCar&lang=zh_TW"
        }
        //Http request governement API and convert response message in JSON format
        AF.request(url).responseJSON { (reseponse) in

            guard let data = reseponse.data else {
                print("Parking Vancancy JSON error")
                return
            }
         //   print("Tap Marker Direction")
         //   print("Tap Marker Direction \(String(describing: data.first))")

            //Decode the JSON into appropriate variables.
            do {
                let jsonData = try JSON(data: data)
                let parks = jsonData["results"].arrayValue
           //     print("getAllVancancy \(parks)")
                for park in parks {

                    let parkId = park.dictionary?["park_Id"]?.string
                    let privateCar = park.dictionary?["privateCar"]?.arrayValue
                    let vancancy = privateCar?[0].dictionary?["vacancy"]?.int
                    let vancancyType = privateCar?[0].dictionary?["vacancy_type"]?.string
                    let lastUpdate = privateCar?[0].dictionary?["lastupdate"]?.string
//                    let privateCar = park["privateCar"].arrayValue
//                    let vancancies = privateCar[0].dictionary
//                    let vancancy = vancancies?["vacancy"]?.string
//                    let lastUpdate = vancancies?["lastupdate"]?.string

                    self.parkingVacancy.append(ParkingVacancy(parkingID: parkId ?? "", vacancyType: vancancyType ?? "B", Vacancy: vancancy ?? 0, lastUpdate: lastUpdate ?? ""))

                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            self.getAllParking()
        }

    }
    
    //Get all parking information from Firebase
    // *Parking information already pre-loaded into Firebase. Datasource from Government Open API
    func getAllParking() {
        let loadingView = LoadingView(frame: CGRect(x: self.view.frame.midX - 40, y: self.view.frame.midY - 100, width: 60, height: 60))
        loadingView.startLoading()
        self.BaseView.addSubview(loadingView)
        
        //Call Parking Service to retrieve information from firebase
        ParkingService.shared.GetAllParking()
        {(parkingList) in
            
            //print("getAllParking: \(parkingList[0].name)")
            var count = 0
            for park in parkingList {
                let vacancyObj = self.parkingVacancy.filter({$0.parkingID == park.postId})
                let vacancy = vacancyObj.first?.Vacancy
                let vacancyType = vacancyObj.first?.vacancyType
                let lastUpdate = vacancyObj.first?.lastUpdate
         //       print("getAllParking: \(park.name)")
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(park.latitude, park.longitude)
                marker.map = self.mapView
                marker.title = park.name
                marker.snippet = NSLocalizedString("TapShow", comment: "")
               // marker.icon = GMSMarker.markerImage(with: .orange)
                //Setup different marker according to parking vacancy status
                var parkIcon = "blueP"
                if vacancy ?? 0 == -1 {
                    parkIcon = "blueP"
                }
                else if vacancy ?? 0 == 1 {
                    if vacancyType ?? "B" == "B"{
                        parkIcon = "greenP"
                    } else {
                        parkIcon = "yellowP"
                    }
                }
                else if vacancy ?? 0 == 0{
                    parkIcon = "redP"
                }
                else if vacancy ?? 0 < 30 {
                    parkIcon = "yellowP"
                }
                else {
                    parkIcon = "greenP"
                }
                let markerImage = UIImage(named: parkIcon)
                let markerView = UIImageView(image: markerImage)
                //markerView.layer.cornerRadius = 90
                markerView.layer.opacity = 0.7
                marker.iconView = markerView
                marker.layer.cornerRadius = 50
                marker.accessibilityLabel = "\(count)"
                self.parkList.append(park)
                count = count + 1
            }
            self.originalList = self.parkList
            self.ButtonList.isEnabled = true
            loadingView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revealViewController()?.gestureEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.revealViewController()?.gestureEnabled = true
    }
    
    //Unwind from Offer Details page, refresh the list
    @IBAction func unwindFromParkingList(segue: UIStoryboardSegue) {
    }
    
    //Prepare the segue of item details/filter selection/sorting selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nav = segue.destination as! UINavigationController
        let destinationController = nav.topViewController as! ParkingListViewController
        destinationController.InputParkingList = self.originalList
        destinationController.Vacancy = self.parkingVacancy
    }
    
    //Return from Comment Page, to add comment to firestore database
    @IBAction func unwindFromParkingRow(_ unwindSegue: UIStoryboardSegue) {
        guard let SourceViewController = unwindSegue.source as? ParkingListViewController
        else {
            print("Fail to Return:")
            return
        }
        
        if self.isLocationEnable == false {
            let alertController = UIAlertController(title: NSLocalizedString("UnableGPS", comment: ""), message: NSLocalizedString("Unable", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let returnRow = SourceViewController.Row
        // MARK: Define the source latitude and longitude
        let sourceLat = self.currentLocation.latitude
        let sourceLng = self.currentLocation.longitude
        self.parkList = SourceViewController.FilterList
            
        // MARK: Define the destination latitude and longitude
        let destinationLat = SourceViewController.FilterList[returnRow].latitude
        let destinationLng = SourceViewController.FilterList[returnRow].longitude
        let title = SourceViewController.FilterList[returnRow].name
        
        self.DestinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        
        let sourceLocation = "\(sourceLat),\(sourceLng)"
        let destinationLocation = "\(destinationLat),\(destinationLng)"
        
        self.SetRoute(sourceLocation: sourceLocation, destinationLocation: destinationLocation, destinationLat: destinationLat, destinationLng: destinationLng, title: title, markerLabel: String(returnRow))
        self.setDistance()
    }
    
    //Call Google map api to setup the route.
    func SetRoute(sourceLocation: String, destinationLocation: String, destinationLat: Double, destinationLng: Double, title: String, markerLabel: String) {
        // MARK: Create URL
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyDKMQDeEltnsXih_O8-6gtqx7kU80l31J8"
        
        print("Tap Marker: \(url)")
        // MARK: Request for response from the google
        self.mapView.clear()
        AF.request(url).responseJSON { (reseponse) in
      //  AF.request(url).responseDecodable(of: T.self) { response in
            
            guard let data = reseponse.data else {
                print("Tap Marker JSON error")
                return
            }
         //   print("Tap Marker Direction")
         //   print("Tap Marker Direction \(String(describing: data.first))")
            
            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                //print("Tap Marker Array Value \(routes)")
                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline.init(path: path)
                 //   print("Tap Marker: \(String(describing: points))")
                    polyline.strokeColor = .blue
                    polyline.strokeWidth = 5
                    polyline.map = self.mapView
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        let Destmarker = GMSMarker()
        Destmarker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        Destmarker.map = self.mapView
        Destmarker.title = title
        //Destmarker.icon = GMSMarker.markerImage(with: .orange)
        Destmarker.icon = UIImage(named: "blueP")
        Destmarker.accessibilityLabel = markerLabel
    }
    
    //Call Google map api to calculate distance and duration
    func setDistance(){
        let centerLat = (currentLocation.latitude + DestinationLocation.latitude)/2
        let centerLng = (currentLocation.longitude + DestinationLocation.longitude)/2
        
        let destination = "\(DestinationLocation.latitude),\(DestinationLocation.longitude)"
        let origins = "\(currentLocation.latitude),\(currentLocation.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destination)&origins=\(origins)&key=AIzaSyDKMQDeEltnsXih_O8-6gtqx7kU80l31J8"
        print(url)
        
        //Call api and convert into JSON format
        AF.request(url).responseJSON { (reseponse) in
            
            guard let data = reseponse.data else {
                print("Distance JSON error")
                return
            }
            print("\(NSLocalizedString("Distance", comment: "")) \(String(describing: data.first))")
            
            //Decode JSON into appropriate variables
            do {
                let jsonData = try JSON(data: data)
                print("\(NSLocalizedString("Distance", comment: "")) \(String(describing: jsonData))")
                let rows = jsonData["rows"].arrayValue
                for row in rows {
                    let elements = row["elements"].arrayValue
                    let distances = elements[0].dictionary?["distance"]?.dictionary
                    self.apiDistance = distances!["value"]!.int ?? 0
                    print("apiDistance: \(self.apiDistance!)")
                    let durations = elements[0].dictionary?["duration"]?.dictionary
                    self.apiDuration = durations!["value"]!.int ?? 0
                }
                if self.apiDistance! < 2000 {
                    self.apiZoom = 15
                }
                else if self.apiDistance! >= 2000, self.apiDistance! < 5000 {
                    self.apiZoom = 14
                }
                else if self.apiDistance! >= 5000, self.apiDistance! < 10000 {
                    self.apiZoom = 13
                }
                else if self.apiDistance! >= 10000, self.apiDistance! < 20000 {
                    self.apiZoom = 12
                }
                else if self.apiDistance! >= 20000, self.apiDistance! < 30000 {
                    self.apiZoom = 11
                }
                else {
                    self.apiZoom = 10
                }
                print("apiDistance: \(self.apiDistance!)")
                print("apiDistance: \(self.apiZoom!)")
                
                
                //setup information and style of bottom view
                let numberOfPlaces = 2.0
                let multiplier = pow(10.0, numberOfPlaces)
                let num = self.apiDistance!/1000
                let durationNum = self.apiDuration!/60
                let DistanceResult = round(Double(num) * multiplier) / multiplier
                let DurationResult = round(Double(durationNum) * multiplier) / multiplier
                
                self.BottomDistance.text = "\(NSLocalizedString("Distance", comment: "")) \(DistanceResult) \(NSLocalizedString("KM", comment: ""))"
                self.BottomDistance.textColor = .white
                self.BottomDuration.text = "\(NSLocalizedString("Duration", comment: "")) \(DurationResult) \(NSLocalizedString("Minutes", comment: ""))"
                self.BottomDuration.textColor = .white
                print("Distance: \(DistanceResult) km")
                print("Duration: \(DurationResult) minutes")
                self.BottomView.backgroundColor = .black
                
                self.BottomView.layer.cornerRadius = 10
                self.BottomView.layer.opacity = 0.7
                self.BaseView.addSubview(self.BottomView)
                
                let RouteTarget = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
                print("SetCam")
                self.mapView.camera = GMSCameraPosition(
                  target: RouteTarget,
                  zoom: self.apiZoom!,
                  bearing: 0,
                  viewingAngle: 0)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }

        
        
        NavButton.isEnabled = true
    }
    
    //Navigation trigger by user, to call Google map service to trigger navigation in Google map apps.
    @IBAction func Navigation(Sender: UIButton){
//        if self.isNav {
//            mapView.camera = GMSCameraPosition(
//              target: self.currentLocation,
//              zoom: 17,
//              bearing: 0,
//              viewingAngle: 70)
//            self.isNav = false
//        } else {
//            mapView.camera = GMSCameraPosition(
//              target: self.currentLocation,
//              zoom: 17,
//              bearing: 0,
//              viewingAngle: 0)
//            self.isNav = true
//        }
        let testURL = URL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL) {
            let directionsRequest = "comgooglemapsurl://www.google.com/maps/dir/?api=1&origin=\(self.currentLocation.latitude),\(self.currentLocation.longitude)&destination=\(self.DestinationLocation.latitude),\(self.DestinationLocation.longitude)&travelmode=driving"

            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL)
        } else {
            let directionsRequest = "https://www.google.com/maps/dir/?api=1&origin=\(self.currentLocation.latitude),\(self.currentLocation.longitude)&destination=\(self.DestinationLocation.latitude),\(self.DestinationLocation.longitude)&travelmode=driving"

            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL)
        }
    }


}


// MARK: - CLLocationManagerDelegate
//1
extension ParkingViewController: CLLocationManagerDelegate {
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

    self.currentLocation = location.coordinate
    self.isLocationEnable = true
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

extension ParkingViewController: GMSMapViewDelegate{
    
    //Setup handler for tap window. To display distance and duration information in bottom view. Call google api to set the route.
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Tap Marker")
        if self.isLocationEnable == false {
            let alertController = UIAlertController(title: NSLocalizedString("UnableGPS", comment: ""), message: NSLocalizedString("Unable", comment: ""), preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        // MARK: Define the source latitude and longitude
        let sourceLat = self.currentLocation.latitude
        let sourceLng = self.currentLocation.longitude
            
        // MARK: Define the destination latitude and longitude
        let destinationLat = marker.position.latitude
        let destinationLng = marker.position.longitude
        
        self.DestinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        
        // MARK: Create source location and destination location so that you can pass it to the URL
        let sourceLocation = "\(sourceLat),\(sourceLng)"
        let destinationLocation = "\(destinationLat),\(destinationLng)"
                
        self.SetRoute(sourceLocation: sourceLocation, destinationLocation: destinationLocation, destinationLat: destinationLat, destinationLng: destinationLng, title: marker.title ?? "N/A", markerLabel: marker.accessibilityLabel!)
        self.setDistance()
        
    }
    
    //Setup custom marker info window.
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel ?? "9999")
        let customInfoWindow = Bundle.main.loadNibNamed("MapMarkerWindowView", owner: self, options: nil)?[0] as! MapMarkerWindow
        guard marker.accessibilityLabel != nil else {
            return customInfoWindow
        }
        let parkID = self.parkList[index!].postId
        let address = self.parkList[index!].displayAddress
        let vacancyObj = self.parkingVacancy.filter({$0.parkingID == parkID})
        let vacancy = vacancyObj.first?.Vacancy
        let vacancyType = vacancyObj.first?.vacancyType
        let lastUpdate = vacancyObj.first?.lastUpdate
        
        //Setup Custom info window style and content.
        customInfoWindow.ParkingName.text = marker.title
        customInfoWindow.ParkingName.textColor = .white
        customInfoWindow.ParkingName.font = UIFont.BlackHeadLine
        if vacancy ?? 0 == -1 {
            customInfoWindow.ParkingSpace.text = NSLocalizedString("VacancyNA", comment: "")
        } else if vacancyType == "B" && vacancy ?? 0 == 1 {
            customInfoWindow.ParkingSpace.text = NSLocalizedString("VacancyAvailable", comment: "")
        }
        else {
            customInfoWindow.ParkingSpace.text = "\(NSLocalizedString("Vacancy", comment: "")) \(String(describing: vacancy ?? 0))"
        }
        customInfoWindow.ParkingSpace.textColor = .white
        customInfoWindow.ParkingSpace.font = UIFont.NormalBody
        customInfoWindow.ParkingVancancy.text = "\(String(describing: lastUpdate ?? "N/A"))"
        customInfoWindow.ParkingVancancy.textColor = .white
        customInfoWindow.ParkingVancancy.font = UIFont.NormalCaption1
     //   customInfoWindow.ParkingAddress.text = "Address: \(address)"
        customInfoWindow.ParkingAddress.text = ""
        customInfoWindow.ParkingAddress.textColor = .white
        customInfoWindow.ParkingLabel.textColor = .white
        customInfoWindow.ParkingLabel.font = UIFont.NormalCaption1
        customInfoWindow.ParkingLabel.text = NSLocalizedString("TapShow", comment: "")
        customInfoWindow.backgroundColor = .black
        customInfoWindow.layer.opacity = 0.7
        customInfoWindow.layer.cornerRadius = 20

        return customInfoWindow
    }
    
}
