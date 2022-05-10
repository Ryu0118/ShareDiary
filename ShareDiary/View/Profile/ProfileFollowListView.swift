//
//  ProfileFollowListView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit

class ProfileFollowListView: UIView, InputAppliable {

    enum Input {
        case setFollowerCount(Int)
        case setFollowCount(Int)
        case setPostCount(Int)
    }

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [followButton, followerButton, postCountButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    private lazy var followButton = HighlightButton(title: "0", subTitle: NSLocalizedString("フォロー", comment: ""))
    private lazy var followerButton = HighlightButton(title: "0", subTitle: NSLocalizedString("フォロワー", comment: ""))
    private lazy var postCountButton = HighlightButton(title: "0", subTitle: NSLocalizedString("投稿数", comment: ""))

    // Initializer
    required init() {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 0, left: 4, bottom: 0, right: 4))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setFollowerCount(let count):
            followerButton.text = "\(count)"
        case .setFollowCount(let count):
            followButton.text = "\(count)"
        case .setPostCount(let count):
            postCountButton.text = "\(count)"
        }
    }

}
