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
                 imageURL: "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://ryu-techblog.com&size=256",
                 followCount: 133,
                 followerCount: 123,
                 followList: ["shibuya", "ryunosuke"],
                 followerList: ["shibuya", "ryunosuke"],
                 uid: Auth.auth().currentUser?.uid ?? "abcdefzrd")
    }

}
