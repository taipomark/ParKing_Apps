//
//  ParkingInfoAPI.swift
//  ParKing
//
//  Created by Mark Lai on 2/5/2022.
//

import Foundation

struct ParkingInfoAPI: Decodable {

    let results: [ParkingDetails]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct ParkingDetails: Decodable {


    let parkId : String?
    let name: String?
    let displayAddress: String?
    let district: String?
    let latitude: Double?
    let longitude: Double?
    let contactNo: String?
    let renditionUrls: renditionUrlsObject?
    let website: String?
    let opening_status: String?
    let heightLimits: [heightLimitsObject]?
//    let privateCar: CarObject?
    
    enum CodingKeys: String, CodingKey {
        case parkId = "park_Id"
        case name = "name"
        case displayAddress = "displayAddress"
        case district = "district"
        case latitude = "latitude"
        case longitude = "longitude"
        case contactNo = "contactNo"
        case renditionUrls = "renditionUrls"
        case website = "website"
        case opening_status = "opening_status"
        case heightLimits = "heightLimits"
//       case privateCar = "privateCar"
    }
    
}

struct renditionUrlsObject: Decodable {
    let carparkPhoto: String?
    
    enum CodingKeys: String, CodingKey {
        case carparkPhoto = "carpark_photo"
    }
}

struct heightLimitsObject: Decodable {
    let height: Double?
    let remark: String?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case remark = "remark"
    }
}
