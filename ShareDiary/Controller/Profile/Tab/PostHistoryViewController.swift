//
//  PostHistoryViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/25.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class PostHistoryViewController: UIViewController {

    let monthCollectionViewController = MonthCollectionViewController()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Theme.Color.Dynamic.appBackgroundColor
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(collectionView)
        self.addChild(monthCollectionViewController)
        collectionView.addSubview(monthCollectionViewController.view)
        monthCollectionViewController.didMove(toParent: self)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        monthCollectionViewController.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.height.equalTo(55)
            $0.width.equalToSuperview()
        }
    }

    private func bind() {

    }

}
