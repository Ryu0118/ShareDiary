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
        self.font = ThemeManager.Font.getAppFont(size: size)
    }

    init(fontSize: ThemeManager.FontSize) {
        super.init(frame: .zero)
        self.font = ThemeManager.Font.getAppFont(size: fontSize.rawValue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
