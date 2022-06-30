//
//  ImpressionView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ImpressionView: UIView, InputAppliable {

    enum Input {
        case setLevels(levels: [ImpressionLevel])// 1...7
    }

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    var levels = [ImpressionLevel]() {
        didSet {
            for level in levels {
                if let impression = getImpressionView(level: level) {
                    impression.setLevel(level: level)
                }
            }
        }
    }

    required init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(stackView)
        for i in (1...7).reversed() {
            let impression = ImpressionDataView()
            let placeholder = ImpressionLevel(level: i, postsCount: 0)
            impression.tag = i
            impression.setLevel(level: placeholder)
            stackView.addArrangedSubview(impression)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 0, left: 0, bottom: 5, right: 0))
        }
    }

    private func getImpressionView(level: ImpressionLevel) -> ImpressionDataView? {
        stackView.arrangedSubviews.first { $0.tag == level.level } as? ImpressionDataView
    }

    func apply(input: Input) {
        switch input {
        case .setLevels(let levels):
            self.levels = levels.sorted(by: { $0.level > $1.level })
        }
    }

}

private class ImpressionDataView: HighlightButton {

    init(level: ImpressionLevel) {
        super.init(title: level.emoji, subTitle: "\(level.postsCount)")
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        textLabel.font = .systemFont(ofSize: 35)
        detailTextLabel.font = Theme.Font.getAppFont(size: 16.5)
    }

    func setLevel(level: ImpressionLevel) {
        textLabel.text = level.emoji
        detailTextLabel.text = "\(level.postsCount)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
