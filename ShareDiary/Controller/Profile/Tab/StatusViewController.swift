//
//  StatusViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/25.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit
import RxDataSources

protocol StatusViewControllerDelegate: AnyObject {
    func statusViewController(_ viewController: UIViewController, didExcessScrollRange heightTranslation: CGFloat)
}

enum StatusSection {
    case titles
    case postsGraph
    case emotions
}

enum StatusItem {
    case title(title: Title)
    case postsGraph(postsData: PostsData)
    case emotions(emotionsData: EmotionsData)
}

typealias StatusSectionModel = SectionModel<StatusSection, StatusItem>

class StatusViewController: UIViewController {

    weak var delegate: StatusViewControllerDelegate?
    private let disposeBag = DisposeBag()
    private let viewModel = StatusViewModel()
    private var scrollFlag = false

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Theme.Color.Dynamic.appBackgroundColor
        tableView.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        tableView.register(PostsGraphTableViewCell.self, forCellReuseIdentifier: PostsGraphTableViewCell.identifier)
        tableView.register(EmotionsTableViewCell.self, forCellReuseIdentifier: EmotionsTableViewCell.identifier)
        tableView.separatorColor = .clear
        return tableView
    }()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<StatusSectionModel>(configureCell: configureCell)

    private lazy var configureCell: RxTableViewSectionedReloadDataSource<StatusSectionModel>.ConfigureCell = {[weak self] _, _, indexPath, item in
        guard let self = self else { return UITableViewCell() }
        switch item {
        case .title(let title):
            return self.titlesCell(indexPath: indexPath, title: title)
        case .postsGraph(let postsData):
            return self.postsGraphCell(indexPath: indexPath, postsData: postsData)
        case .emotions(let emotionsData):
            return self.emotionsCell(indexPath: indexPath, emotionsData: emotionsData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bind()
    }

    func setScrollEnabled(_ isEnabled: Bool) {
        print(isEnabled)
        if !scrollFlag {
            tableView.isScrollEnabled = isEnabled
        }
    }

    private func setupViews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

    private func bind() {

        var previousTranslation = CGFloat(0)

        tableView.panGestureRecognizer.rx.event
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { strong, gesture in
                switch gesture.state {
                case .began, .changed:
                    if strong.tableView.contentOffset.y <= 0 || strong.scrollFlag {
                        let translateY = gesture.translation(in: strong.tableView).y

                        print(translateY - previousTranslation, previousTranslation)
                        strong.delegate?.statusViewController(strong, didExcessScrollRange: translateY - previousTranslation)
                        previousTranslation = translateY

                        strong.scrollFlag = true
                    }
                case .ended, .cancelled:
                    previousTranslation = 0
                    if strong.tableView.contentOffset.y <= 0 {
                        strong.scrollFlag = false
                        strong.setScrollEnabled(false)
                    }
                default:
                    previousTranslation = 0
                    if strong.tableView.contentOffset.y <= 0 {
                        strong.setScrollEnabled(false)
                    }
                }

            })
            .disposed(by: disposeBag)

        tableView.rx.didScroll
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                if self.tableView.contentOffset.y <= 0 {
                    self.tableView.contentOffset.y = 0
                    // self.setScrollEnabled(false)

                } else {
                    // self.setScrollEnabled(true)
                }
            }
            .disposed(by: disposeBag)

        viewModel.outputs.titles
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

    }

}

extension StatusViewController {

    private func titlesCell(indexPath: IndexPath, title: Title) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier, for: indexPath) as? TitlesTableViewCell {
            cell.apply(input: .setTitle(title: title))
            return cell
        }
        return UITableViewCell()
    }

    private func postsGraphCell(indexPath: IndexPath, postsData: PostsData) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostsGraphTableViewCell.identifier, for: indexPath) as? PostsGraphTableViewCell {

            return cell
        }
        return UITableViewCell()
    }

    private func emotionsCell(indexPath: IndexPath, emotionsData: EmotionsData) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmotionsTableViewCell.identifier, for: indexPath) as? EmotionsTableViewCell {

            return cell
        }
        return UITableViewCell()
    }

}

extension StatusViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = StatusHeaderView()
            return header
        }
        else {
            return UIView()
        }
    }
    
}
