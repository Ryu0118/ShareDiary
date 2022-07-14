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
        collectionView.backgroundColor = UserSettings.shared.dynamicBackgroundColor
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }

    private func setupView() {
        view.addSubview(collectionView)
        self.addChild(monthCollectionViewController)
        collectionView.addSubview(monthCollectionViewController.view)
        monthCollectionViewController.didMove(toParent: self)
    }

    private func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        monthCollectionViewController.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.height.equalTo(110)
            $0.width.equalToSuperview()
        }
    }

    private func bind() {

    }

}
