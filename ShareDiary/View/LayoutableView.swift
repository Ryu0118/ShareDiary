//
//  LayoutableView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/02.
//

import UIKit

class LayoutableView: UIView {

    var layoutBlock: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutBlock?()
    }

}

class LayoutableLabel: UILabel {

    var layoutBlock: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutBlock?()
    }

}
