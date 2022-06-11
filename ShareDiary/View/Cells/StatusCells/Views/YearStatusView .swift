//
//  YearStatusView .swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class YearStatusView: UIView, InputAppliable {

    enum Input {
        case setPostsData(year: Int, postsCount: Int)
    }

    private var postsData: (year: Int, postsCount: Int)! {
        didSet {
            postsCountView.apply(inputs: [
                .setTitle("日記の投稿数"),
                .setStatus(postsData.postsCount)
            ])

            if Date().getYear() == postsData.year {
                let firstDate = Calendar(identifier: .gregorian)
                    .date(from: DateComponents(year: postsData.year, month: 1, day: 1 )) ?? Date()
                let elapsed = Date().difference(firstDate) + 1
                let progress = CGFloat(postsData.postsCount) / CGFloat(elapsed)

                entireView.apply(input: .setTitle("\(postsData.year)年の経過日数"))
                entireView.apply(input: .setStatus(elapsed))

                circleProgressView.setProgress(progress, animated: true)
                progressLabel.text = Int(progress * 100).toString() + "%"
            } else {
                let firstDate = Calendar(identifier: .gregorian)
                    .date(from: DateComponents(year: postsData.year, month: 1, day: 1 )) ?? Date()
                let lastDate = Calendar(identifier: .gregorian)
                    .date(from: DateComponents(year: postsData.year, month: 12, day: 31)) ?? Date()
                let elapsed = firstDate.difference(lastDate) + 1
                let progress = CGFloat(postsData.postsCount) / CGFloat(elapsed)

                entireView.apply(input: .setTitle("\(postsData.year)年の日数"))
                entireView.apply(input: .setStatus(elapsed))
                circleProgressView.setProgress(progress, animated: true)
                progressLabel.text = Int(progress * 100).toString() + "%"
            }
        }
    }

    private lazy var entireView: StatusView = {
        let status = StatusView(frame: .zero)
        return status
    }()

    private lazy var postsCountView: StatusView = {
        let status = StatusView(frame: .zero)
        return status
    }()

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [entireView, postsCountView])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [circleProgressView, verticalStackView])
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .horizontal
        // stack.spacing = 12
        return stack
    }()

    private lazy var minVstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [achieveLabel, progressLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private lazy var circleProgressView: SRCircleProgress = {
        let progressView = SRCircleProgress(frame: .zero)
        progressView.circleBackgroundColor = Theme.Color.progressBackgroundColor
        progressView.progressColor = Theme.Color.appThemeDeepColor
        progressView.progressLineWidth = 6
        progressView.animationDuration = 0.3
        progressView.backgroundLineWidth = progressView.progressLineWidth
        return progressView
    }()

    private var achieveLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppFont(size: 13)
        label.text = "投稿達成率"
        label.textColor = Theme.Color.Dynamic.textGray
        return label
    }()

    private var progressLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppBoldFont(size: 20)
        return label
    }()

    init() {
        super.init(frame: .zero)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(horizontalStackView)
        circleProgressView.addSubview(minVstack)

        horizontalStackView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.9)
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.83)
        }

        verticalStackView.snp.makeConstraints {
            $0.height.equalTo(horizontalStackView)
        }

        circleProgressView.snp.makeConstraints {
            $0.width.height.equalTo(120)
        }

        minVstack.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        entireView.snp.makeConstraints {
            $0.width.equalTo(self).multipliedBy(0.4)
            $0.height.equalTo(55)
        }

        postsCountView.snp.makeConstraints {
            $0.width.equalTo(self).multipliedBy(0.4)
            $0.height.equalTo(55)
        }

    }

    func apply(input: Input) {
        switch input {
        case .setPostsData(let year, let postsCount):
            self.postsData = (year, postsCount)
        }
    }

}