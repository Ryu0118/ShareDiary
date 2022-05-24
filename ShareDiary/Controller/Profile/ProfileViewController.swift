//
//  ProfileViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileHeaderViewController = ProfileHeaderViewController(userInfo: UserInfoMock.createMock())

    private var contentStackView: UIStackView = {
        let stack = UIStackView()
        // profileHeaderViewController, tab, scrollView
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.delegate = self
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ProfileViewController: UIScrollViewDelegate {

}
