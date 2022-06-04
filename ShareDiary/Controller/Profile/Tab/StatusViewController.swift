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
}

enum StatusSection {
    case titles
    case postsGraph
    case emotions
}

enum StatusItem {
    case title(title: Title)
    case postsGraph(postsData: [PostsData])
    case emotions(emotionsData: EmotionsData)
}

typealias StatusSectionModel = SectionModel<StatusSection, StatusItem>

class StatusViewController: UIViewController {

    weak var delegate: StatusViewControllerDelegate?
    private let disposeBag = DisposeBag()
    private let viewModel = StatusViewModel()
    private var scrollFlag = false
    private var isScrollEnabled = false

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = Theme.Color.Dynamic.appBackgroundColor
        tableView.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        tableView.register(PostsGraphTableViewCell.self, forCellReuseIdentifier: PostsGraphTableViewCell.identifier)
        tableView.register(EmotionsTableViewCell.self, forCellReuseIdentifier: EmotionsTableViewCell.identifier)
        tableView.separatorColor = .clear
        return tableView
    }()

    private let headerTitles = [
        NSLocalizedString("称号", comment: ""),
        NSLocalizedString("投稿数", comment: "")
    ]

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<StatusSectionModel>(configureCell: configureCell, titleForHeaderInSection: titleForHeader)

    private lazy var titleForHeader: RxTableViewSectionedReloadDataSource<StatusSectionModel>.TitleForHeaderInSection = { _, section -> String? in
        return self.headerTitles[section]
    }

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
        tableView.isScrollEnabled = isEnabled
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }

    private func bind() {

        viewModel.outputs.statuses
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }

}

extension StatusViewController {

    private func titlesCell(indexPath: IndexPath, title: Title) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier, for: indexPath) as? TitlesTableViewCell {
            cell.apply(input: .setTitle(title: title))
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    private func postsGraphCell(indexPath: IndexPath, postsData: [PostsData]) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostsGraphTableViewCell.identifier, for: indexPath) as? PostsGraphTableViewCell {
            cell.apply(input: .setPostsData(postsData: postsData))
            cell.selectionStyle = .none
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
        } else {
            return UIView()
        }
    }

}
