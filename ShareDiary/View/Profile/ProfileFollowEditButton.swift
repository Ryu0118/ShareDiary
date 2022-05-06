//
//  ProfileFollowEditButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit

class ProfileFollowEditButton: InteractiveButton {

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
        case .myProfile:
            return Theme.Color.appThemeColor
        case .otherProfile:
            return Theme.Color.Dynamic.appTextColorInvert
        }
    }

    // MARK: Initializer
    init(style: ProfileHeaderViewController.ProfileStyle) {
        self.style = style
        super.init(frame: .zero)

        self.backgroundColor = buttonBackgroundColor
        self.setTitle(buttonTitle, for: .normal)
        self.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        setup()
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

}

extension ProfileFollowEditButton {

    private func setup() {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            self.layer.borderWidth = 1
            self.layer.borderColor = Theme.Color.textGray.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }

}
