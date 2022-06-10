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
        case setYearPostsCount(year: Int, postsCount: Int)
    }

    var monthPostsCount = 0
    var yearPostsCount = 0
    var month = 0
    var year = 0

    let grayAttribute: [NSAttributedString.Key: Any] = [
        .font: Theme.Font.getAppFont(size: 22),
        .foregroundColor: Theme.Color.Dynamic.textGray
    ]
    let boldAttribute: [NSAttributedString.Key: Any] = [
        .font: Theme.Font.getAppBoldFont(size: 22),
        .foregroundColor: Theme.Color.Dynamic.appTextColor,
        .baselineOffset: 0
    ]

    lazy var yearStatus: (year: Int, postsCount: Int) = (year: year, postsCount: yearPostsCount) {
        didSet {
            //            let grayString = NSAttributedString(string: "\(year)年の投稿数: ", attributes: grayAttribute)
            //            let boldString = NSAttributedString(string: yearStatus.postsCount.toString(), attributes: boldAttribute)
            //
            //            let mutableString = NSMutableAttributedString()
            //            mutableString.append(grayString)
            //            mutableString.append(boldString)
            //
            //            yearStatusLabel.attributedText = mutableString
            //            yearStatusLabel.textAlignment = .center
            guard let monthString = Months.getMonthString(month: monthStatus.month) else { return }
            let grayString = NSAttributedString(string: year.toString() + "年" + monthString + "の投稿数: ", attributes: grayAttribute)
            let boldString = NSAttributedString(string: monthPostsCount.toString(), attributes: boldAttribute)

            let mutableString = NSMutableAttributedString()
            mutableString.append(grayString)
            mutableString.append(boldString)

            monthStatusLabel.attributedText = mutableString
            monthStatusLabel.textAlignment = .center
        }
    }

    lazy var monthStatus: (month: Int, postsCount: Int) = (month: month, postsCount: monthPostsCount) {
        didSet {
            guard let monthString = Months.getMonthString(month: monthStatus.month) else { return }
            let grayString = NSAttributedString(string: year.toString() + "年" + monthString + "の投稿数: ", attributes: grayAttribute)
            let boldString = NSAttributedString(string: monthPostsCount.toString(), attributes: boldAttribute)

            let mutableString = NSMutableAttributedString()
            mutableString.append(grayString)
            mutableString.append(boldString)

            monthStatusLabel.attributedText = mutableString
            monthStatusLabel.textAlignment = .center
        }
    }

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [monthStatusLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 25
        return stack
    }()

    lazy var monthStatusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()

    lazy var yearStatusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
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
            self.monthPostsCount = postsCount
            self.monthStatus = (month: month, postsCount: postsCount)
        case .setYearPostsCount(let year, let postsCount):
            self.yearPostsCount = postsCount
            self.year = year
            self.yearStatus = (year: year, postsCount: yearPostsCount)
        }
    }

    private func setupViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension Int {
    func toString() -> String {
        "\(self)"
    }
}
