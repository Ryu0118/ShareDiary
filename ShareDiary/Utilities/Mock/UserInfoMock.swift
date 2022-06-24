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
        UserInfo(name: "りゅう",
                 userID: "ryuryuuuu",
                 image: R.image.nouser() ?? UIImage(),
                 discription: "大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,大学二年生, 電気電子工学科大学二年生,",
                 postCount: 1000,
                 imageURL: "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://ryu-techblog.com&size=256",
                 followCount: 133,
                 followerCount: 123,
                 followList: ["shibuya", "ryunosuke"],
                 followerList: ["shibuya", "ryunosuke"],
                 uid: Auth.auth().currentUser?.uid ?? "abcdefzrd")
    }

}
