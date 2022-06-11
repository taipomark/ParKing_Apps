//
//  ParkingService.swift
//  ParKing
//
//  Created by Mark Lai on 4/5/2022.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

//Parking service for getting parking information from firebase
final class ParkingService {

    // Init

    static let shared: ParkingService = ParkingService()

    private init() { }

    // MARK: - Firebase Database Reference

    let BASE_DB_REF: DatabaseReference = Database.database().reference()

    let POST_DB_REF: DatabaseReference = Database.database().reference().child("ParkingInfoEN")
    let POST_DB_REF_ZH: DatabaseReference = Database.database().reference().child("ParkingInfoZH")
    
    //Get All parking information
    func GetAllParking(completionHandler: @escaping ([ParkingDBInfo]) -> Void) {
       // var parkingList: [ParkingDBInfo]!
        var parkingList: [ParkingDBInfo] = []
        let langStr = Locale.current.languageCode!
        if langStr == "en" {
            POST_DB_REF.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
         //       print("snapshot count = \(snapshot.childrenCount)")
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let postInfo = item.value as? [String: Any] ?? [:]
                    if let post = ParkingDBInfo(postId: item.key, parkingInfo: postInfo) {
                        parkingList.append(post)
                    }
                }

                completionHandler(parkingList)
            })
        }
        else {
            POST_DB_REF_ZH.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
         //       print("snapshot count = \(snapshot.childrenCount)")
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let postInfo = item.value as? [String: Any] ?? [:]
                    if let post = ParkingDBInfo(postId: item.key, parkingInfo: postInfo) {
                        parkingList.append(post)
                    }
                }

                completionHandler(parkingList)
            })
        }
        
        
                         
        

    }
    

}
