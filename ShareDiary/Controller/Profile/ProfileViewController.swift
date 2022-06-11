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
    private var goingUp = false
    private var childScrollingDownDueToParent = false
    private var previousOffset = CGFloat(0)
    private var previousDelta = CGFloat(0)

    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)

        // statusViewController?.setScrollEnabled(false)
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
extension ProfileViewController {

    private func bind() {

        //        scrollView.rx.didScroll
        //            .observe(on: MainScheduler.asyncInstance)
        //            .subscribe {[weak self] _ in
        //                guard let self = self else { return }
        //                if self.scrollView.contentOffset.y + self.scrollView.frame.size.height >= self.scrollView.contentSize.height && self.scrollView.isDragging {
        //                    self.scrollView.contentOffset.y = self.scrollView.contentSize.height - self.scrollView.frame.size.height
        //                    self.statusViewController?.setScrollEnabled(true)
        //                } else {
        //                    self.statusViewController?.setScrollEnabled(false)
        //                }
        //            }
        //            .disposed(by: disposeBag)
        //
        scrollView.delegate = self
        statusViewController?.tableView.delegate = self

    }

}

extension ProfileViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // determining whether scrollview is scrolling up or down
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0

        // maximum contentOffset y that parent scrollView can have
        let parentScrollView = self.scrollView
        let childScrollView = self.statusViewController?.tableView ?? UITableView()
        let parentViewMaxContentYOffset = parentScrollView.contentSize.height - parentScrollView.frame.height

        // if scrollView is going upwards
        if goingUp {
            // if scrollView is a child scrollView
            // print("goingUp")

            if scrollView == childScrollView {
                // print("scrollView is tableView")
                // if parent scroll view isn't scrolled maximum (i.e. menu isn't sticked on top yet)
                if parentScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    // print("scrollViewのcontentOffsetがMaxContentOffSet以下かつchildScrollingDownDueToParentがfalse")
                    // change parent scrollView contentOffset y which is equal to minimum between maximum y offset that parent scrollView can have and sum of parentScrollView's content's y offset and child's y content offset. Because, we don't want parent scrollView go above sticked menu.
                    // Scroll parent scrollview upwards as much as child scrollView is scrolled
                    // Sometimes parent scrollView goes in the middle of screen and stucks there so max is used.
                    parentScrollView.contentOffset.y = max(min(parentScrollView.contentOffset.y + childScrollView.contentOffset.y, parentViewMaxContentYOffset), 0)

                    // change child scrollView's content's y offset to 0 because we are scrolling parent scrollView instead with same content offset change.
                    childScrollView.contentOffset.y = 0
                }
            }
        }
        // Scrollview is going downwards
        else {
            // print("goingDownGrade")
            if scrollView == childScrollView {
                // print("スクロールビューがtableViewならば")
                // when child view scrolls down. if childScrollView is scrolled to y offset 0 (child scrollView is completely scrolled down) then scroll parent scrollview instead
                // if childScrollView's content's y offset is less than 0 and parent's content's y offset is greater than 0
                if childScrollView.contentOffset.y < 0 && parentScrollView.contentOffset.y > 0 {
                    print("tableViewのcontentOffsetYが0以下かつscrollViewのcontentOffsetYが0以上")
                    // set parent scrollView's content's y offset to be the maximum between 0 and difference of parentScrollView's content's y offset and absolute value of childScrollView's content's y offset
                    // we don't want parent to scroll more that 0 i.e. more downwards so we use max of 0.
                    let offsetY = parentScrollView.contentOffset.y - abs(childScrollView.contentOffset.y)
                    // print(offsetY, parentScrollView.contentOffset.y, childScrollView.contentOffset.y, parentViewMaxContentYOffset, previousOffset)
                    let diff = parentScrollView.contentOffset.y - previousOffset
                    previousOffset = parentScrollView.contentOffset.y

                    parentScrollView.contentOffset.y = max(offsetY, 0)
                    //                    if parentScrollView.contentOffset.y == parentViewMaxContentYOffset {
                    //                        parentScrollView.contentOffset.y = max(offsetY, 0)
                    //                    } else {
                    //                        print(diff)
                    //                        parentScrollView.contentOffset.y -= max(diff, 0)
                    //                    }
                }
            }

            // if downward scrolling view is parent scrollView
            if scrollView == parentScrollView {
                // print("スクロールビューがparentScrollViewならば")
                // if child scrollView's content's y offset is greater than 0. i.e. child is scrolled up and content is hiding up
                // and parent scrollView's content's y offset is less than parentView's maximum y offset
                // i.e. if child view's content is hiding up and parent scrollView is scrolled down than we need to scroll content of childScrollView first
                if childScrollView.contentOffset.y > 0 && parentScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    // print("tableViewのcontentOffsetYが0以上かつscrollViewのcontentOffsetYがscrollViewのcontentOffsetMaxならば")
                    // set if scrolling is due to parent scrolled
                    childScrollingDownDueToParent = true
                    // assign the scrolled offset of parent to child not exceding the offset 0 for child scroll view
                    childScrollView.contentOffset.y = max(childScrollView.contentOffset.y - (parentViewMaxContentYOffset - parentScrollView.contentOffset.y), 0)
                    // stick parent view to top coz it's scrolled offset is assigned to child
                    parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
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
