//
//  PostsData.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import Foundation

struct PostsData {
    let year: Int
    let data: [Int]
    var postsCount: Int {
        data.reduce(0) { $0 + $1 }
    }
}
