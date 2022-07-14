//
//  ProfileFollowEditButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit

class ProfileFollowEditButton: InteractiveButton, InputAppliable {

    enum Input {
        case setProfileStyle(ProfileHeaderViewController.ProfileStyle)
    }

    private var settings = UserSettings.shared

    var style: ProfileHeaderViewController.ProfileStyle
    var buttonTitle: String {
        switch style {
        case .myProfile:
            return NSLocalizedString("プロフィールを編集", comment: "")
        case .otherProfile:
            return NSLocalizedString("フォロー", comment: "")
        }
    }

    var buttonBackgroundColor: UIColor {
        switch style {
        case .otherProfile:
            return settings.themeColor
        case .myProfile:
            return settings.dynamicTextColorInvert
        }
    }

    var buttonColor: UIColor {
        switch style {
        case .otherProfile:
            return .white
        case .myProfile:
            return settings.dynamicTextColor
        }
    }

    // MARK: Initializer
    init(style: ProfileHeaderViewController.ProfileStyle = .otherProfile) {
        self.style = style
        super.init(frame: .zero)

        setup()
        self.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setup()
    }

    func apply(input: Input) {
        switch input {
        case .setProfileStyle(let style):
            self.style = style
            self.setup()
        }
    }

}

extension ProfileFollowEditButton {

    private func setup() {
        self.setTitle(buttonTitle, for: .normal)
        self.backgroundColor = buttonBackgroundColor
        self.setTitleColor(buttonColor, for: .normal)
        if style == .myProfile {
            self.layer.borderWidth = 1
            self.layer.borderColor = settings.textGray.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }

}
