//
//  Post.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/26.
//

import Foundation
import FirebaseAuth

struct Post {
    let id: UUID
    let name: String
    let userName: String
    let firebaseUID: String
    let date: Date
    let message: String
    let impressionLevel: Int// 1...7
    let comment: [String]
    let imageURLs: [URL]
    let goodUserNames: [String]

    var impressionString: String {
        [
            "😰",
            "😭",
            "😞",
            "😶",
            "😀",
            "😄",
            "😆"
        ][impressionLevel - 1]
    }

    var isOwnPost: Bool {
        Auth.auth().currentUser?.uid == firebaseUID
    }
}
