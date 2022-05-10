//
//  UserInfo.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/03.
//

import UIKit

struct UserInfo {
    let name: String
    let userID: String// @abcdef
    let image: UIImage
    let discription: String
    let postCount: Int
    var imageURL = ""
    var followCount = 0
    var followerCount = 0
    var followList = [String]()// userID
    var followerList = [String]()// userID
    var uid = ""

    init(name: String,
         userID: String,
         image: UIImage,
         discription: String,
         postCount: Int,
         imageURL: String = "",
         followCount: Int = 0,
         followerCount: Int = 0,
         followList: [String] = [],
         followerList: [String] = [],
         uid: String = ""
    ) {
        self.name = name
        self.userID = userID
        self.image = image
        self.discription = discription
        self.postCount = postCount
        self.imageURL = imageURL
        self.followCount = followCount
        self.followerCount = followerCount
        self.followerList = followerList
        self.uid = uid
    }
}
