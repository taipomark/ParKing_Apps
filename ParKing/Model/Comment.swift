//
//  Comment.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import Foundation

struct Comment {
    var postId: String
    let CommentTitle : String
    let CommentType: String
    let Content: String
    let Date: String
    let ReportEmail: String
    let ReportUser: String
    
    enum CommentKeys{
        
        static let CommentTitle = "CommentTitle"
        static let CommentType = "CommentType"
        static let Content = "Content"
        static let Date = "Date"
        static let ReportEmail = "ReportEmail"
        static let ReportUser = "ReportUser"
    }
    
    init(postId: String, CommentTitle: String, CommentType: String, Content: String, Date: String, ReportEmail: String, ReportUser: String) {
            self.postId = postId
            self.CommentTitle = CommentTitle
            self.CommentType = CommentType
            self.Content = Content
            self.Date = Date
            self.ReportEmail = ReportEmail
            self.ReportUser = ReportUser
        }
    
    init?(postId: String, commentInfo: [String: Any]) {
        guard let CommentTitle = commentInfo[CommentKeys.CommentTitle] as? String,
              let CommentType = commentInfo[CommentKeys.CommentType] as? String,
              let Content = commentInfo[CommentKeys.Content] as? String,
              let Date = commentInfo[CommentKeys.Date] as? String,
              let ReportEmail = commentInfo[CommentKeys.ReportEmail] as? String,
              let ReportUser = commentInfo[CommentKeys.ReportUser] as? String
            else {

                return nil
            }

        self = Comment(postId: postId, CommentTitle: CommentTitle, CommentType: CommentType, Content: Content, Date: Date, ReportEmail: ReportEmail, ReportUser: ReportUser)
    }

}
