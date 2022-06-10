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
            PostsData(year: 2021, data: [7, 2, 0, 13, 22, 9, 6, 8, 5, 4, 6, 12]),
            PostsData(year: 2020, data: [10, 22, 30, 13, 22, 10, 6, 8, 13, 4, 6, 24]),
            PostsData(year: 2019, data: [2, 6, 24, 13, 24, 10, 14, 8, 18, 4, 6, 30])
        ]
    }

}
