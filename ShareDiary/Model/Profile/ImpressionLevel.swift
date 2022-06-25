//
//  ImpressionLevel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/25.
//

import Foundation

struct ImpressionLevel {
    let level: Int
    let postsCount: Int
    var emoji: String {
        emojies[level - 1]
    }

    private let emojies = [
        "😰",
        "😭",
        "😞",
        "😶",
        "😀",
        "😄",
        "😆"
    ]
}
