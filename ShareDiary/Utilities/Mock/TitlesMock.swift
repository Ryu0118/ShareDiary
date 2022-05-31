//
//  TitlesMock.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/29.
//

import Foundation

class TitlesMock {

    static func createMock() -> [Title] {
        [Title(
            titleName: "連続投稿",
            terms: [
                Title.Term(grade: .gold,
                           termName: "一年",
                           isAchieved: true),
                Title.Term(grade: .silver,
                           termName: "一ヶ月",
                           isAchieved: true),
                Title.Term(grade: .bronze,
                           termName: "一週間",
                           isAchieved: true)
            ]
        ),
        Title(
            titleName: "投稿数",
            terms: [
                Title.Term(grade: .gold,
                           termName: "500",
                           isAchieved: false),
                Title.Term(grade: .silver,
                           termName: "100",
                           isAchieved: false),
                Title.Term(grade: .bronze,
                           termName: "10",
                           isAchieved: true)
            ]
        ),
        Title(
            titleName: "課金",
            terms: [
                Title.Term(grade: .gold,
                           termName: "一年",
                           isAchieved: false),
                Title.Term(grade: .silver,
                           termName: "半年",
                           isAchieved: false),
                Title.Term(grade: .bronze,
                           termName: "一ヶ月",
                           isAchieved: false)
            ]
        )
        ]
    }

}
