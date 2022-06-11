//
//  ParkingDBInfo.swift
//  ParKing
//
//  Created by Mark Lai on 4/5/2022.
//

import Foundation

//For Parking information object from firebase
struct ParkingDBInfo {
    var postId: String
    let carParkPhoto : String
    let contactNo: String
    let displayAddress: String
    let district: String
    let latitude: Double
    let longitude: Double
    let name: String
    let opening_status: String
    let website: String

    
    enum ParkingKeys{
        
        static let carParkPhoto = "carParkPhoto"
        static let contactNo = "contactNo"
        static let displayAddress = "displayAddress"
        static let district = "district"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let name = "name"
        static let opening_status = "opening_status"
        static let website = "website"
    }
    
    init(postId: String, carParkPhoto: String, contactNo: String, displayAddress: String, district: String, latitude: Double, longitude: Double, name: String, opening_status: String, website: String) {
            self.postId = postId
            self.carParkPhoto = carParkPhoto
            self.contactNo = contactNo
            self.displayAddress = displayAddress
            self.district = district
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
            self.opening_status = opening_status
            self.website = website
        }
    
    init?(postId: String, parkingInfo: [String: Any]) {
        let carParkPhoto = parkingInfo[ParkingKeys.carParkPhoto] as? String
        let contactNo = parkingInfo[ParkingKeys.contactNo] as? String
        let displayAddress = parkingInfo[ParkingKeys.displayAddress] as? String
        let district = parkingInfo[ParkingKeys.district] as? String
        let latitude = parkingInfo[ParkingKeys.latitude] as? Double
        let longitude = parkingInfo[ParkingKeys.longitude] as? Double
        let name = parkingInfo[ParkingKeys.name] as? String
        let opening_status = parkingInfo[ParkingKeys.opening_status] as? String
        let website = parkingInfo[ParkingKeys.website] as? String
        
        self = ParkingDBInfo(postId: postId, carParkPhoto: carParkPhoto ?? "N/A", contactNo: contactNo ?? "N/A", displayAddress: displayAddress ?? "N/A", district: district ?? "N/A", latitude: latitude!, longitude: longitude!, name: name ?? "N/A", opening_status: opening_status ?? "OPEN", website: website ?? "N/A")
    }

}

