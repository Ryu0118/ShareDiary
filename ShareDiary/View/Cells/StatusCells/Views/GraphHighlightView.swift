//
//  GraphHighlightView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/04.
//

import UIKit
import SnapKit

class GraphHighlightView: UIView, InputAppliable {

    enum Input {
        case setMonthPostsCount(month: Int, postsCount: Int)
    }

    var postsCount: Int = 0
    var month: Int = 0

    lazy var monthStatus: (month: Int, postsCount: Int) = (month: month, postsCount: postsCount) {
        didSet {
            print(monthStatus.month, monthStatus.postsCount)
            guard let monthString = Months.getMonthString(month: monthStatus.month) else { return }

            let grayAttribute: [NSAttributedString.Key: Any] = [
                .font: Theme.Font.getAppFont(size: 16),
                .foregroundColor: Theme.Color.Dynamic.textGray
            ]
            let boldAttribute: [NSAttributedString.Key: Any] = [
                .font: Theme.Font.getAppBoldFont(size: 25),
                .foregroundColor: Theme.Color.Dynamic.appTextColor,
                .baselineOffset: -3
            ]

            let grayString = NSAttributedString(string: monthString + "の投稿数: ", attributes: grayAttribute)
            let boldString = NSAttributedString(string: postsCount.toString(), attributes: boldAttribute)

            let mutableString = NSMutableAttributedString()
            mutableString.append(grayString)
            mutableString.append(boldString)

            monthStatusLabel.attributedText = mutableString
            monthStatusLabel.textAlignment = .center
        }
    }

    lazy var monthStatusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setMonthPostsCount(let month, let postsCount):
            self.month = month
            self.postsCount = postsCount
            self.monthStatus = (month: month, postsCount: postsCount)
        }
    }

    private func setupViews() {
        addSubview(monthStatusLabel)

        monthStatusLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension Int {
    func toString() -> String {
        "\(self)"
    }
}
