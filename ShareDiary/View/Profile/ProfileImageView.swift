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
            self.removeConstraints(self.constraints)
            self.snp.makeConstraints {
                $0.width.height.equalTo(diameter)
            }
        }
    }

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}
