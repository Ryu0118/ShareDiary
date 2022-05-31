//
//  StatusHeaderView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StatusHeaderView: UIView, InputAppliable {

    enum Input {
        case setSectionName(name: String)
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setSectionName(let name):
            break
        }
    }

}
