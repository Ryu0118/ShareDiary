//
//  ProfileHeaderViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import SnapKit
import SwiftUI
import UIKit
import FirebaseAuth

class ProfileHeaderViewController: UIViewController {

    enum ProfileStyle {
        case myProfile
        case otherProfile
    }

    var userInfo: UserInfo

    let userInfoViewController = ProfileUserInfoViewController()
    let followListViewController = ProfileFollowListViewController()
    let followEditViewController = ProfileFollowEditViewController()

    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()

    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UserSettings.shared.dynamicTextColorInvert
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        apply()
    }

    override func loadView() {
        super.loadView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setup() {

        view.addSubview(stackView)

        self.addChild(userInfoViewController)
        self.addChild(followListViewController)
        self.addChild(followEditViewController)

        stackView.addArrangedSubviews([
            userInfoViewController.view,
            followListViewController.view,
            followEditViewController.view
        ])

        userInfoViewController.didMove(toParent: self)
        followListViewController.didMove(toParent: self)
        followEditViewController.didMove(toParent: self)

        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        stackView.setContentCompressionResistancePriority(.required, for: .vertical)

        userInfoViewController.view.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        followListViewController.view.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        followEditViewController.view.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

    }

    private func addContainerView(child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func apply() {

        let profileStyle: ProfileHeaderViewController.ProfileStyle = .myProfile

        self.userInfoViewController.userInfoView.apply(inputs: [
            .setProfileStyle(style: profileStyle),
            .setName(name: userInfo.name),
            .setUserName(userName: userInfo.userID),
            .setImage(image: userInfo.image),
            .setImageForURL(url: userInfo.imageURL),
            .setUserIntroduction(introduction: userInfo.discription)
        ])

        self.followListViewController.followListView.apply(inputs: [
            .setPostCount(userInfo.postCount),
            .setFollowCount(userInfo.followCount),
            .setFollowerCount(userInfo.followerCount)
        ])

        self.followEditViewController.followEditButton.apply(input:
                                                                .setProfileStyle(profileStyle)
        )

    }

}

struct ProfileHeaderViewControllerWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ProfileHeaderViewController {
        let mock = UserInfo(name: "澁谷りゅうのすけ", userID: "shibuya0118", image: R.image.nouser() ?? UIImage(), discription: "大学一年生, 電気電子工学科大学一年生", postCount: 365, imageURL: "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://ryu-techblog.com&size=256", followCount: 133, followerCount: 1234, followList: ["shibuya", "ryunosuke"], followerList: ["shibuya", "ryunosuke"], uid: Auth.auth().currentUser?.uid ?? "abcdefzrd")
        let vc = ProfileHeaderViewController(userInfo: mock)
        return vc
    }

    func updateUIViewController(_ vc: ProfileHeaderViewController, context: Context) {
        vc.apply()
    }
}

struct ProfileHeaderViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileHeaderViewControllerWrapper()
                .previewDevice("iPhone 13")
        }
    }
}
