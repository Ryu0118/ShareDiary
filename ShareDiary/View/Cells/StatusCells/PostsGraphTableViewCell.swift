//
//  PostsGraphTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import SnapKit

class PostsGraphTableViewCell: UITableViewCell, InputAppliable {

    enum Input {
        case setPostsData(postsData: [PostsData])
    }

    var postsData = [PostsData]() {
        didSet {
            guard let presentYearData = postsData.sorted(by: { $0.year > $1.year }).first else { return }

            postsControlView.apply(input: .setAllowedYears(years: postsData.map { "\($0.year)" }))
            graphHighlightView.apply(input: .setYearPostsCount(year: presentYearData.year, postsCount: presentYearData.postsCount))
            yearStatusView.apply(inputs: [
                .setPostsData(year: presentYearData.year, postsCount: presentYearData.postsCount)
            ])
        }
    }

    private var postsControlView = GraphControlView()
    private var graphHighlightView = GraphHighlightView()
    private var postsGraphView = PostsGraphView()
    private var yearStatusView = YearStatusView()
    private var impressionView = ImpressionView()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [postsControlView, graphHighlightView, postsGraphView, yearStatusView, impressionView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private let disposeBag = DisposeBag()

    static let identifier = "PostsGraphTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setPostsData(let postsData):
            self.postsData = postsData
            if let data = postsData[safe: 0] {
                postsGraphView.apply(input: .setPostsData(postsData: data))
            }
        }
    }

    private func setupViews() {
        contentView.addSubview(stackView)
        postsGraphView.barChartView.delegate = self
        setupConstraints()
    }

    private func setupConstraints() {

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 8, left: 8, bottom: 8, right: 8))
        }

        postsGraphView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(200)
        }

        postsControlView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(35)
        }

        graphHighlightView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(37)
        }

        yearStatusView.snp.makeConstraints {
            $0.height.equalTo(140)
            $0.width.equalToSuperview()
        }

        impressionView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }

    }

    private func bind() {

        Observable.merge(
            postsControlView.viewModel.outputs.backButtonDidPressed.asObservable(),
            postsControlView.viewModel.outputs.forwardButtonDidPressed.asObservable()
        )
        .asDriver(onErrorJustReturn: 0)
        .drive { [weak self] currentIndex in
            guard let self = self else { return }
            if let postsData = self.postsData[safe: currentIndex] {
                self.postsGraphView.apply(input: .setPostsData(postsData: postsData))
                self.graphHighlightView.apply(input: .setYearPostsCount(year: postsData.year, postsCount: postsData.postsCount))
                self.yearStatusView.apply(inputs: [
                    .setPostsData(year: postsData.year, postsCount: postsData.postsCount)
                ])
            }
        }
        .disposed(by: disposeBag)

    }

}

extension PostsGraphTableViewCell: ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        let postsCount = Int(entry.y)

        graphHighlightView.apply(input: .setMonthPostsCount(month: index + 1, postsCount: postsCount))
    }

}
