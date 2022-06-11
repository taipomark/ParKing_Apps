//
//  ParkingRealtimeAPI.swift
//  ParKing
//
//  Created by Mark Lai on 2/5/2022.
//

import Foundation
struct ParkingRealtimeAPI: Decodable {

    let results: [RealtimeDetails]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct RealtimeDetails: Decodable {

    let parkId : String?
    let privateCar: [CarObject]?

    enum CodingKeys: String, CodingKey {
        case parkId = "park_Id"
        case privateCar = "privateCar"
    }
    
}

struct CarObject: Decodable {
    let vacancy_type: String?
    let vacancy: Int?
    let lastupdate: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case vacancy_type = "vacancy_type"
        case vacancy = "vacancy"
        case lastupdate = "lastupdate"
        case category = "category"
    }
}
