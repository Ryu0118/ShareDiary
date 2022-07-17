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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: PostImageCell.identifier)
        return collectionView
    }()

    private let cellPadding = CGFloat(8)
    private let cellWidth = CGFloat(150)

    private var keyObserver: NSKeyValueObservation?
    private let disposeBag = DisposeBag()

    var imageURLs: [URL]! {
        didSet {

            do {
                collectionView.contentInset = try calculateCollectionViewInset()
            } catch {
                keyObserver = collectionView.observe(\.frame, options: .new, changeHandler: {[weak self] collectionView, observationChange in
                    guard let self = self,
                          let _ = observationChange.newValue?.width,
                          let inset = try? self.calculateCollectionViewInset()
                    else { return }

                    collectionView.contentInset = inset
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    deinit {
        keyObserver?.invalidate()
        keyObserver = nil
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

    private func bind() {

        collectionView.rx
            .itemSelected
            .withUnretained(self)
            .map { strong, indexPath -> UIImage? in
                let cell = strong.collectionView.visibleCells[safe: indexPath.row] as? PostImageCell
                return cell?.uiImage
            }
            .asDriver(onErrorJustReturn: nil)
            .drive { uiImage in
                guard let uiImage = uiImage else { return }
                // TODO: 画像をタップした時に拡大表示する.
            }
            .disposed(by: disposeBag)

    }

}

extension PostImageCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        cellPadding
    }

}

extension PostImageCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostImageCell.identifier,
                for: indexPath) as? PostImageCell,
              let url = imageURLs[safe: indexPath.row]
        else { return UICollectionViewCell() }

        cell.apply(input: .setImageURL(url: url))

        return cell
    }

}

// Calculate UICollectionView Insets
extension PostImageCollectionViewController {

    enum RenderingError: Error {
        case zeroWidth
    }

    func calculateCollectionViewInset() throws -> UIEdgeInsets {
        let collectionViewWidth = collectionView.frame.size.width

        guard collectionViewWidth != 0 else { throw RenderingError.zeroWidth }

        let cellCount = collectionView.visibleCells.count
        let estimatedWidth = (0..<cellCount).reduce(0) { prev, _ -> CGFloat in
            prev + cellWidth + cellPadding
        } - cellPadding

        if estimatedWidth < collectionViewWidth {
            let estimatedPadding = (collectionViewWidth - estimatedWidth) / 2
            return UIEdgeInsets(top: collectionView.contentInset.top, left: estimatedPadding, bottom: collectionView.contentInset.bottom, right: collectionView.contentInset.right)
        } else {
            return collectionView.contentInset
        }
    }

}
