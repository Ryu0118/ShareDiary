//
//  HighlightButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit

class HighlightButton: InteractiveButton {

    // MARK: Stored Property
    private let settings = UserSettings.shared

    lazy var textLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 16)
        label.textColor = settings.dynamicTextColor
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()

    lazy var detailTextLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 12)
        label.textColor = settings.dynamicTextGray
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textLabel, detailTextLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 3
        stack.isUserInteractionEnabled = false
        return stack
    }()

    // MARK: Computed Property
    var text: String {
        get {
            textLabel.text ?? ""
        }
        set {
            textLabel.text = newValue
        }
    }

    var detailText: String {
        get {
            detailTextLabel.text ?? ""
        }
        set {
            detailTextLabel.text = newValue
        }
    }

    // MARK: Initializer
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        self.text = title
        self.detailText = subTitle

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HighlightButton {

    private func setup() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        detailTextLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

}
