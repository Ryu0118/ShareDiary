//
//  ViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/29.
//
import UIKit
import FirebaseAuth

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTab()
        view.backgroundColor = .white
    }

    func setupTab() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: NSLocalizedString("ホーム", comment: ""), image: R.image.home()?.iconSize, tag: 0)
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("プロフィール", comment: ""), image: R.image.user()?.iconSize, tag: 0)
        UITabBar.appearance().tintColor = Theme.Color.appThemeDeepColor
        UITabBar.appearance().backgroundColor = Theme.Color.appBackgroundColor

        viewControllers = [homeVC, profileVC]
    }

}
