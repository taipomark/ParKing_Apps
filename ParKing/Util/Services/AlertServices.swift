//
//  AlertServices.swift
//  ParKing
//
//  Created by Mark Lai on 1/5/2022.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

//Alert firebase service, to add/retrieve alert information from/to firebase
final class AlertService {
    
    // Init

    static let shared: AlertService = AlertService()

    private init() { }
    
    let POST_DB_REF: DatabaseReference = Database.database().reference().child("ParkingAlert")
    
    func AddNewAlert(alertData: [String : Any]!, completionHandler: @escaping () -> Void) {

        POST_DB_REF.childByAutoId().setValue(alertData)
        completionHandler()
    }
    
    //Get Alert from firebase.
    func GetAlert(completionHandler: @escaping ([Report]) -> Void) {
        
        var alertList: [Report] = []

        let date = Date()
     //   let yesterday = Date().dayBefore
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        let today = format.string(from: date) + "000000"
        print("Today: \(today)")
        //Alert > Today Day start
        POST_DB_REF.queryOrdered(byChild: "Date").queryStarting(atValue: today).observe(.value, with: { snapshot in
            //queryStarting(atValue: today)
       // POST_DB_REF.observe(.value, with: { snapshot in
            //    print("Alert service count: \(snapshot.childrenCount)")
     //              print("snapshot count = \(snapshot.childrenCount)")
                for item in snapshot.children.allObjects as! [DataSnapshot] {
      //              print("Alert service enter loop")
                    let reportInfo = item.value as? [String: Any] ?? [:]
                    if let post = Report(postId: item.key, reportInfo: reportInfo) {
                        alertList.append(post)
       //                 print("AlertService post: \(post)")
                    }
                }

                completionHandler(alertList)
            })
        
    }
    
    //Get Reported Alert by user
    func GetReportedAlert(completionHandler: @escaping ([Report]) -> Void) {
        
        var alertList: [Report] = []
        let userID = Auth.auth().currentUser!.uid
        
        //Retrieve Alert Reported list by user ID
        POST_DB_REF.queryOrdered(byChild: "ReportByUserID").queryEqual(toValue: userID).observe(.value, with: { snapshot in
            print("GetReportedAlert count \(snapshot.childrenCount)")
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let reportInfo = item.value as? [String: Any] ?? [:]
                if let post = Report(postId: item.key, reportInfo: reportInfo) {
                    alertList.append(post)
                }
            }
            completionHandler(alertList)
        })
            
        
    }
    
    
    
}

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
