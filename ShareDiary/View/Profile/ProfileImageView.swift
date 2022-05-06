//
//  ProfileImageView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/05.
//
import UIKit
import SnapKit

class ProfileImageView: InteractiveImageView {

    enum Input {
        case setImageDiameter(diameter: CGFloat)
    }

    func apply(input: Input) {
        switch input {
        case .setImageDiameter(let diameter):
            self.snp.makeConstraints {
                $0.width.height.equalTo(diameter)
            }
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }

}
