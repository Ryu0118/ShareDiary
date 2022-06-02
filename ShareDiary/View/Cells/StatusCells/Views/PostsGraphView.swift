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
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.xAxis.valueFormatter = PostsGraphIAxisValueFormatter()
        barChartView.xAxis.labelCount = 12
        return barChartView
    }

    private func createBarChartData(postsData: PostsData) -> BarChartData {
        let entries: [BarChartDataEntry] = postsData.data.enumerated().map {
            let (i, postsCount) = $0
            return BarChartDataEntry(x: Double(i), y: Double(postsCount))
        }
        let barChartDataSet = BarChartDataSet(entries: entries, label: "")
        barChartDataSet.colors = entries.map { _ in UIColor.systemBlue }
        barChartDataSet.drawValuesEnabled = false
        return BarChartData(dataSet: barChartDataSet)
    }

}

class PostsGraphIAxisValueFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        Months.getMonths()[Int(value)]
    }
}

private class Months {

    static func getMonths() -> [String] {
        [
            NSLocalizedString("1月", comment: ""),
            NSLocalizedString("2月", comment: ""),
            NSLocalizedString("3月", comment: ""),
            NSLocalizedString("4月", comment: ""),
            NSLocalizedString("5月", comment: ""),
            NSLocalizedString("6月", comment: ""),
            NSLocalizedString("7月", comment: ""),
            NSLocalizedString("8月", comment: ""),
            NSLocalizedString("9月", comment: ""),
            NSLocalizedString("10月", comment: ""),
            NSLocalizedString("11月", comment: ""),
            NSLocalizedString("12月", comment: "")
        ]
    }

}
