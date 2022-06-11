//
//  Report.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import Foundation

//For Reported Alert object from firebase
struct Report {
    var postId: String
    let ReportBy: String
    let ReportByUserID: String
    let Date: String
    let Lat: Double
    let Long: Double
    let Status: String

    
    enum ReportKeys{
        
        static let ReportBy = "ReportBy"
        static let ReportByUserID = "ReportByUserID"
        static let Date = "Date"
        static let Lat = "Lat"
        static let Long = "Long"
        static let Status = "Status"
    }
    
    init(postId: String, ReportBy: String, ReportByUserID: String, Date: String, Lat: Double, Long: Double, Status: String) {
            self.postId = postId
            self.ReportBy = ReportBy
            self.ReportByUserID = ReportByUserID
            self.Date = Date
            self.Lat = Lat
            self.Long = Long
            self.Status = Status
        }
    
    init?(postId: String, reportInfo: [String: Any]) {

        guard let ReportBy = reportInfo[ReportKeys.ReportBy] as? String,
              let ReportByUserID = reportInfo[ReportKeys.ReportByUserID] as? String,
              let Date = reportInfo[ReportKeys.Date] as? String,
              let Lat = reportInfo[ReportKeys.Lat] as? Double,
              let Long = reportInfo[ReportKeys.Long] as? Double,
              let Status = reportInfo[ReportKeys.Status] as? String
            else {
      //          print("AlertService null")
                return nil
            }
        
       // print("AlertService OK")

        self = Report(postId: postId, ReportBy: ReportBy, ReportByUserID: ReportByUserID, Date: Date, Lat: Lat, Long: Long, Status: Status)
    }

}
