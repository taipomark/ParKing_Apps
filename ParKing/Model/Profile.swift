//
//  Profile.swift
//  ParKing
//
//  Created by Mark Lai on 26/4/2022.
//

import Foundation


struct Profile {
    var postId: String
    let Email : String
    let UserName: String
    let ProfilePic: String
    let Gender: String
    let CreateDate: String
    
    enum ProfileKeys{
        
        static let Email = "Email"
        static let UserName = "UserName"
        static let ProfilePic = "ProfilePic"
        static let Gender = "Gender"
        static let CreateDate = "CreateDate"
    }
    
    init(postId: String, Email: String, UserName: String, ProfilePic: String, Gender: String, CreateDate: String) {
            self.postId = postId
            self.Email = Email
            self.UserName = UserName
            self.ProfilePic = ProfilePic
            self.Gender = Gender
            self.CreateDate = CreateDate
        }
    
    init?(postId: String, profileInfo: [String: Any]) {
        guard let Email = profileInfo[ProfileKeys.Email] as? String,
              let UserName = profileInfo[ProfileKeys.UserName] as? String,
              let ProfilePic = profileInfo[ProfileKeys.ProfilePic] as? String,
              let Gender = profileInfo[ProfileKeys.Gender] as? String,
              let CreateDate = profileInfo[ProfileKeys.CreateDate] as? String
            else {

                return nil
            }

        self = Profile(postId: postId, Email: Email, UserName: UserName, ProfilePic: ProfilePic, Gender: Gender, CreateDate: CreateDate)
    }

}
