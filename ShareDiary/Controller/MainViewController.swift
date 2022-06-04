//
//  ViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/29.
//
import UIKit
import FirebaseAuth

class MainViewController: UITabBarController {

    private let stackView: UIStackView = {
        let statusBarView = UIView()
        let bottomToolBarView = UIView()
        statusBarView.backgroundColor = Theme.Color.Dynamic.appThemeColor
        bottomToolBarView.backgroundColor = Theme.Color.Dynamic.appBackgroundColor
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTab()
        view.backgroundColor = Theme.Color.appThemeLightColor
    }

    func setupTab() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: NSLocalizedString("ホーム", comment: ""), image: R.image.home()?.iconSize, tag: 0)
        let profileVC = ProfileViewController(userInfo: UserInfoMock.createMock())
        profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("プロフィール", comment: ""), image: R.image.user()?.iconSize, tag: 0)
        UITabBar.appearance().tintColor = Theme.Color.appThemeDeepColor
        UITabBar.appearance().backgroundColor = Theme.Color.appBackgroundColor

        viewControllers = [homeVC, profileVC]
    }

}
