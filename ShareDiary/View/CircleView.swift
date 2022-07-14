//
//  CircleView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/30.
//

import UIKit

class CircleView: LayoutableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutBlock = {
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
