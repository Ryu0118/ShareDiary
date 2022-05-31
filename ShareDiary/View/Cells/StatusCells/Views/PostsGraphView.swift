//
//  PostsGraphView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/29.
//

import UIKit
import SnapKit
import Charts
import RxSwift
import RxCocoa

class PostsGraphView: UIView, InputAppliable {

    enum Input {
        case setPostsData(postsData: PostsData)
    }

    var barChartView = BarChartView(frame: .zero)

    var postsData = PostsData(year: 0, data: []) {
        didSet {
            barChartView.data = createBarChartData(postsData: postsData)
        }
    }

    init() {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setPostsData(let postsData):
            self.postsData = postsData
            break
        }
    }

    private func setupViews() {
        barChartView = createBarChartView()
        addSubview(barChartView)
    }

    private func setupConstraints() {
        barChartView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createBarChartView() -> BarChartView {
        barChartView.data = createBarChartData(postsData: postsData)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        return barChartView
    }

    private func createBarChartData(postsData: PostsData) -> BarChartData {
        let entries: [BarChartDataEntry] = postsData.data.enumerated().map {
            let (i, postsCount) = $0
            return BarChartDataEntry(x: Double(i), y: Double(postsCount))
        }
        let barChartDataSet = BarChartDataSet(entries: entries, label: "")
        return BarChartData(dataSet: barChartDataSet)
    }

}
