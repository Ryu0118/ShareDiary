//
//  Post.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/26.
//

import Foundation

struct Post {
    let id: UUID
    let name: String
    let userName: String
    let firebaseUserName: String
    let date: Date
    let message: String
    let impressionLevel: Int// 1...7
    let comment: [String]
    let imageURLs: [URL]
    
    var impresionString: String {
        return [
            "😰",
            "😭",
            "😞",
            "😶",
            "😀",
            "😄",
            "😆"
        ][impressionLevel - 1]
    }
}
