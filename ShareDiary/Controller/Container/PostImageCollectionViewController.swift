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

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let cellPadding = CGFloat(8)
    private let cellWidth = CGFloat(150)
    
    private var keyObserver: NSKeyValueObservation?

    var imageURLs: [URL]! {
        didSet {
            zip(collectionView.visibleCells, imageURLs).forEach { cell, url in
                guard let cell = cell as? PostImageCell else { return }
                cell.apply(input: .setImageURL(url: url))
            }
            
            do {
                collectionView.contentInset = try calculateCollectionViewInset()
            }
            catch {
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

}

//Calculate UICollectionView Insets
extension PostImageCollectionViewController {
    
    enum RenderingError: Error {
        case zeroWidth
    }
    
    func calculateCollectionViewInset() throws -> UIEdgeInsets {
        let collectionViewWidth = collectionView.frame.size.width
        
        guard collectionViewWidth != 0 else { throw RenderingError.zeroWidth }
        
        let cellCount = collectionView.visibleCells.count
        let estimatedWidth = (0..<cellCount).reduce(0) { (prev, _) -> CGFloat in
            prev + cellWidth + cellPadding
        } - cellPadding
        
        if estimatedWidth < collectionViewWidth {
            let estimatedPadding = (collectionViewWidth - estimatedWidth) / 2
            return UIEdgeInsets(top: collectionView.contentInset.top, left: estimatedPadding, bottom: collectionView.contentInset.bottom, right: collectionView.contentInset.right)
        }
        else {
            return collectionView.contentInset
        }
    }
    
}
