//
//  WorldLifeLabel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit

class WorldLifeLabel: UILabel {

    init(size: CGFloat) {
        super.init(frame: .zero)
        self.font = Theme.Font.getAppFont(size: size)
        setup()
    }

    init(fontSize: Theme.FontSize) {
        super.init(frame: .zero)
        self.font = Theme.Font.getAppFont(size: fontSize.rawValue)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = 0
        self.sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
