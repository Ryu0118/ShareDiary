//
//  EmotionsTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import UIKit

class EmotionsTableViewCell: UITableViewCell {

    static let identifier = "EmotionsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
