//
//  ProfileViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import SnapKit
import Parchment

class ProfileViewController: UIViewController {

    // MARK: ContainerView
    private let profileHeaderViewController = ProfileHeaderViewController(userInfo: UserInfoMock.createMock())
    private let titles: [String] = [
        NSLocalizedString("ステータス", comment: ""),
        NSLocalizedString("投稿", comment: ""),
        NSLocalizedString("いいね", comment: "")
    ]
    private lazy var viewControllers: [UIViewController] = [
        StatusViewController(),
        PostHistoryViewController(),
        GoodViewController()
    ]
    private lazy var tabController: PagingViewController = {
        let pagingVC = PagingViewController(viewControllers: viewControllers)
        pagingVC.selectedBackgroundColor = .clear
        pagingVC.indicatorColor = Theme.Color.appThemeDeepColor
        pagingVC.textColor = .black
        pagingVC.selectedTextColor = Theme.Color.appThemeDeepColor// blue white
        pagingVC.menuBackgroundColor = Theme.Color.Dynamic.appTextColorInvert
        pagingVC.borderColor = .clear
        pagingVC.delegate = self
        pagingVC.dataSource = self
        pagingVC.menuItemSize = .sizeToFit(minWidth: 30, height: pagingVC.menuItemSize.height)
        return pagingVC
    }()
    private var statusViewController: StatusViewController? {
        tabController.children[safe: 0] as? StatusViewController
    }
    private var postHistoryViewController: PostHistoryViewController? {
        tabController.children[safe: 1] as? PostHistoryViewController
    }
    private var goodViewController: GoodViewController? {
        tabController.children[safe: 2] as? GoodViewController
    }

    // MARK: Layout Guide

    private lazy var guideStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tabBarGuideView, pageGuideView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        tabBarGuideView.snp.makeConstraints {
            $0.height.equalTo(tabController.menuItemSize.height)
        }
        return stack
    }()

    private lazy var tabBarGuideView = UIView()

    private lazy var pageGuideView = UIView()

    // MARK: MainViews
    private var mainStackView: UIStackView = {
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

        setupViews()
        setupConstraints()
    }

    // MARK: Views setup

    private func setupViews() {
        view.addSubviews([guideStackView, scrollView])
        scrollView.addSubview(mainStackView)

        self.addChild(tabController)
        self.addChild(profileHeaderViewController)
        mainStackView.addArrangedSubviews([
            profileHeaderViewController.view,
            tabController.view
        ])
        tabController.didMove(toParent: self)
        profileHeaderViewController.didMove(toParent: self)

    }

    private func setupConstraints() {

        guideStackView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.snp.makeConstraints {
            $0.left.top.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }

        tabController.pageViewController.view.snp.makeConstraints {
            $0.height.equalTo(pageGuideView.snp.height)
            $0.width.equalToSuperview()
        }

        tabController.view.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

        profileHeaderViewController.view.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(150)
            $0.width.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

    }

}

// MARK: Methods
extension ProfileViewController: UIScrollViewDelegate {

}

extension ProfileViewController: PagingViewControllerDelegate, PagingViewControllerDataSource {

    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewControllers.count
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        viewControllers[index]
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        PagingIndexItem(index: index, title: titles[index])
    }

}
