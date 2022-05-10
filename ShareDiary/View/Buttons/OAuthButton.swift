//
//  OAuthButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import UIKit
import SnapKit

class OAuthButton: InteractiveButton {

    let oauthImage: UIImage?

    init(image: UIImage?) {
        self.oauthImage = image
        super.init(frame: .zero)
        setup()
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.layoutBlock = {
            self.layer.cornerRadius = self.frame.height / 2
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        let imageView = UIImageView(image: oauthImage?.iconSize)
        addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }

    }

}
