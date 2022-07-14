//
//  MonthCollectionViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MonthCollectionViewCell: UICollectionViewCell, InputAppliable {

    static let identifier = "MonthCollectionViewCell"

    enum Input {
        case setMonth(month: Int)
        case setSelected(selected: Bool)
    }

    private let settings = UserSettings.shared

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [monthLabel, gatuLabel])
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()

    private lazy var monthLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppBoldFont(size: 18)
        label.textAlignment = .center
        label.textColor = settings.dynamicTextColor
        return label
    }()

    private lazy var gatuLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(frame: .zero)
        label.font = Theme.Font.getAppFont(size: 14)
        label.textAlignment = .center
        label.textColor = settings.dynamicTextGray
        label.text = "月"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = settings.dynamicThemeColor.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.borderColor = settings.dynamicThemeColor.cgColor
        layer.cornerRadius = 20
        layer.borderWidth = 2
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func apply(input: Input) {
        switch input {
        case .setMonth(let month):
            monthLabel.text = "\(month)"
        case .setSelected(let selected):
            backgroundColor = selected ? settings.dynamicThemeColor : settings.dynamicTextColorInvert
            monthLabel.textColor = selected ? UIColor.white : settings.dynamicTextColor
            gatuLabel.textColor = selected ? UIColor.white : settings.dynamicTextGray
        }
    }

}
