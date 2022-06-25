//
//  MonthCollectionViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/25.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class MonthCollectionViewController: UIViewController {

    private var months: [Int] = {
        let current = Date()
        let currentMonth = current.getMonth()
        return [Int](1...currentMonth)
    }() {
        didSet {
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset.left = 14
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.identifier)
        return collectionView
    }()

    private let yearControlView = YearControlView()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [yearControlView, collectionView])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    func setYear(year: Int) {
        if Date().getYear() == year {
            self.months = {
                let current = Date()
                let currentMonth = current.getMonth()
                return [Int](1...currentMonth)
            }()
        } else {
            self.months = [Int](1...12)
        }
    }

    private func setupCollectionView() {
        view.addSubview(stackView)
        view.backgroundColor = .clear

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.width.equalToSuperview()
        }

        yearControlView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalToSuperview().multipliedBy(0.9)
        }

    }

}

extension MonthCollectionViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        months.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.identifier, for: indexPath) as? MonthCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.apply(inputs: [
            .setMonth(month: months[indexPath.row]),
            .setSelected(selected: false)
        ])
        if indexPath.row == Date().getMonth() - 1 {
            cell.apply(input: .setSelected(selected: true))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MonthCollectionViewCell
        collectionView.visibleCells.forEach { cell in
            guard let cell = cell as? MonthCollectionViewCell else { return }
            cell.apply(input: .setSelected(selected: false))
        }
        cell?.apply(input: .setSelected(selected: true))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        14
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        14
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 55)
    }

}
