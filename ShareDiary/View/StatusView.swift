//
//  StatusView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StatusView: UIView, InputAppliable {

    enum Input {
        case setTitle(String)
        case setStatus(Int)
    }

    private var titleLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppFont(size: 13)
        label.textColor = Theme.Color.Dynamic.textGray
        return label
    }()

    private var statusLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppBoldFont(size: 25)
        label.textColor = Theme.Color.Dynamic.appTextColor
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, statusLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.layer.cornerRadius = 13
        self.backgroundColor = Theme.Color.Dynamic.appBackgroundColor
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.85)
        }
    }

    func apply(input: Input) {
        switch input {
        case .setTitle(let title):
            titleLabel.text = title
        case .setStatus(let status):
            statusLabel.text = status.toString()
        }
    }

}
