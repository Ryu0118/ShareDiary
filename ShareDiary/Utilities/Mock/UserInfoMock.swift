//
//  UserInfoMock.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/10.
//

import UIKit
import FirebaseAuth

class UserInfoMock {

    static func createMock() -> UserInfo {
        UserInfo(name: "りゅうのすけ",
                 userID: "shibuya0118",
                 image: R.image.nouser() ?? UIImage(),
                 discription: "大学一年生, 電気電子工学科大学一年生, 電気電子工学科大学一年生, 電気電子工学科大学一年生, 電気電子工学科大学一年生, 電気電子工学科大学一年生, 電気電子工学科大学一年生, 電気電子工学科",
                 postCount: 365,
                 imageURL: "https://firebasestorage.googleapis.com/v0/b/sharediary-da22f.appspot.com/o/users%2Fryu.jpg?alt=media&token=899fc9bc-c26a-4e3d-a28b-40ab6d3fc537",
                 followCount: 133,
                 followerCount: 123,
                 followList: ["shibuya", "ryunosuke"],
                 followerList: ["shibuya", "ryunosuke"],
                 uid: Auth.auth().currentUser?.uid ?? "abcdefzrd")
    }

}
