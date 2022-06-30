//
//  PostsData.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/29.
//

import Foundation

class PostsDataMock {

    static func createMock() -> [PostsData] {
        [
            PostsData(year: 2022, data: [7, 2, 0, 13, 22, 9, 6, 8, 5, 4, 6, 12], impressionLevels: [
                ImpressionLevel(level: 1, postsCount: 10),
                ImpressionLevel(level: 2, postsCount: 19),
                ImpressionLevel(level: 3, postsCount: 1),
                ImpressionLevel(level: 4, postsCount: 5),
                ImpressionLevel(level: 5, postsCount: 7),
                ImpressionLevel(level: 6, postsCount: 9),
                ImpressionLevel(level: 7, postsCount: 10)
            ]),
            PostsData(year: 2021, data: [7, 2, 0, 13, 22, 9, 6, 8, 5, 4, 6, 12], impressionLevels: [
                ImpressionLevel(level: 1, postsCount: 10),
                ImpressionLevel(level: 2, postsCount: 19),
                ImpressionLevel(level: 3, postsCount: 1),
                ImpressionLevel(level: 4, postsCount: 5),
                ImpressionLevel(level: 5, postsCount: 7),
                ImpressionLevel(level: 6, postsCount: 9),
                ImpressionLevel(level: 7, postsCount: 10)
            ]),
            PostsData(year: 2020, data: [10, 22, 30, 13, 22, 10, 6, 8, 13, 4, 6, 24], impressionLevels: [
                ImpressionLevel(level: 1, postsCount: 10),
                ImpressionLevel(level: 2, postsCount: 19),
                ImpressionLevel(level: 3, postsCount: 1),
                ImpressionLevel(level: 4, postsCount: 5),
                ImpressionLevel(level: 5, postsCount: 7),
                ImpressionLevel(level: 6, postsCount: 9),
                ImpressionLevel(level: 7, postsCount: 10)
            ]),
            PostsData(year: 2019, data: [2, 6, 24, 13, 24, 10, 14, 8, 18, 4, 6, 30], impressionLevels: [
                ImpressionLevel(level: 1, postsCount: 10),
                ImpressionLevel(level: 2, postsCount: 19),
                ImpressionLevel(level: 3, postsCount: 1),
                ImpressionLevel(level: 4, postsCount: 5),
                ImpressionLevel(level: 5, postsCount: 7),
                ImpressionLevel(level: 6, postsCount: 9),
                ImpressionLevel(level: 7, postsCount: 10)
            ])
        ]
    }

}
