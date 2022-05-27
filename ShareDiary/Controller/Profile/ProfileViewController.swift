//
//  ProfileViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Parchment

class ProfileViewController: UIViewController {

    // MARK: ContainerView
    private lazy var profileHeaderViewController = ProfileHeaderViewController(userInfo: userInfo)
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
        viewControllers[safe: 0] as? StatusViewController
    }
    private var postHistoryViewController: PostHistoryViewController? {
        viewControllers[safe: 1] as? PostHistoryViewController
    }
    private var goodViewController: GoodViewController? {
        viewControllers[safe: 2] as? GoodViewController
    }

    // MARK: Layout Guide

    private lazy var guideStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerGuideView, tabBarGuideView, pageGuideView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        tabBarGuideView.snp.makeConstraints {
            $0.height.equalTo(tabController.menuItemSize.height)
        }
        headerGuideView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return stack
    }()

    private lazy var tabBarGuideView = UIView()
    private lazy var headerGuideView = UIView()
    private lazy var headerMockView = UIView()
    private lazy var pageGuideView = UIView()

    // MARK: MainViews
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 16.5)
        label.textColor = Theme.Color.Dynamic.appTextColor
        label.text = userInfo.name
        return label
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Color.Dynamic.appThemeColor
        view.clipsToBounds = true
        return view
    }()

    let userInfo: UserInfo
    private let disposeBag = DisposeBag()

    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)

        statusViewController?.setScrollEnabled(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        bind()
    }

    // MARK: Views setup

    private func setupViews() {
        statusViewController?.delegate = self
        view.addSubviews([guideStackView, scrollView, headerView])
        headerView.addSubview(titleLabel)
        scrollView.addSubviews([mainStackView])

        self.addChild(tabController)
        self.addChild(profileHeaderViewController)
        mainStackView.addArrangedSubviews([
            headerMockView,
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

        headerView.snp.makeConstraints {
            $0.left.top.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(headerGuideView)
        }

        headerMockView.snp.makeConstraints {
            $0.height.equalTo(headerGuideView)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.greaterThanOrEqualTo(headerView.snp.centerY).priority(.required)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(profileHeaderViewController.userInfoViewController.userInfoView.nameLabel.snp.bottom).priority(.high)
        }

    }

}

// MARK: Methods
extension ProfileViewController: UIScrollViewDelegate {

    private func bind() {

        scrollView.rx.didScroll
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] _ in
                guard let self = self else { return }
                if self.scrollView.contentOffset.y + self.scrollView.frame.size.height >= self.scrollView.contentSize.height && self.scrollView.isDragging {
                    self.scrollView.contentOffset.y = self.scrollView.contentSize.height - self.scrollView.frame.size.height
                    self.statusViewController?.setScrollEnabled(true)
                } else {
                    self.statusViewController?.setScrollEnabled(false)
                }
            }
            .disposed(by: disposeBag)

    }

}

extension ProfileViewController: StatusViewControllerDelegate {

    func statusViewController(_ viewController: UIViewController, didExcessScrollRange heightTranslation: CGFloat) {
        //        if scrollView.contentOffset.y > 0 {
        //            scrollView.contentOffset.y -= heightTranslation
        //        } else {
        //            scrollView.contentOffset.y = 0
        //        }
    }

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
