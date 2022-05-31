//
//  PostsGraphTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import UIKit
import Charts

class PostsGraphTableViewCell: UITableViewCell, InputAppliable {

    enum Input {
        case setPostsData(postsData: [PostsData])
    }

    static let identifier = "PostsGraphTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setPostsData(let postsData):
            break
        }
    }

    private func setupCharts() {

    }

}
