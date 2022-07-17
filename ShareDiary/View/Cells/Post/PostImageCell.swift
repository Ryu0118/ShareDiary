//
//  PostImageCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/07/15.
//

import UIKit
import SDWebImage
import SnapKit
import Rswift

class PostImageCell: UICollectionViewCell, InputAppliable {

    static let identifier = "PostImageCell"

    enum Input {
        case setImageURL(url: URL)
    }

    var url: URL? {
        didSet {
            let placeholderImage = UIImage()
            imageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
    }

    var uiImage: UIImage? {
        imageView.image
    }

    private var imageView = UIImageView(image: R.image.noImage())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setImageURL(let url):
            self.url = url
        }
    }

    private func setupViews() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
