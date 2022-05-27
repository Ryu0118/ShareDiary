//
//  EmotionsData.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import Foundation

struct EmotionsData {
    let emojies = [
        "😆",
        "😃",
        "🙂",
        "😐",
        "😮‍💨",
        "😪",
        "🤧",
        "🥵",
        "🥶"
    ]
    let lank: Int // 1-9
    func getEmoji() -> String {
        if let emoji = emojies[safe: lank - 1] {
            return emoji
        } else {
            fatalError("Unexpected lank")
        }
    }
}
