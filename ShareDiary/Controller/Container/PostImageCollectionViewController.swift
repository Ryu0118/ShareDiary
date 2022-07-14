//
//  PostImageCollectionViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PostImageCollectionViewController: UIViewController, InputAppliable {

    enum Input {
        case setImageURLs(urls: [URL])
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    var imageURLs: [URL]! {
        didSet {
            // TODO: imageの数に合わせてcollectionViewのinsetを変化させる
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func apply(input: Input) {
        switch input {
        case .setImageURLs(let urls):
            self.imageURLs = urls
        }
    }

    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
