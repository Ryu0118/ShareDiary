// 
//  ImpressionView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ImpressionView: UIView, InputAppliable {

    enum Input {
        case setLevels(levels: [ImpressionLevel])//1...7
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    var levels = [ImpressionLevel]() {
        didSet {
            for level in levels {
                if let impression = getImpressionView(level: level) {
                    impression.setLevel(level: level)
                }
            }
        }
    }

    required init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        for i in 1...7 {
            let impression = Impression()
            impression.tag = i
            stackView.addArrangedSubview(impression)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func getImpressionView(level: ImpressionLevel) -> Impression? {
        stackView.arrangedSubviews.filter { $0.tag == level.level }.first as? Impression
    }

    func apply(input: Input) {
        switch input {
        case .setLevels(let levels):
            self.levels = levels.sorted(by: { $0.level < $1.level })
        }
    }
 
}

fileprivate class Impression: HighlightButton {

    init(level: ImpressionLevel) {
        super.init(title: level.emoji, subTitle: "\(level.postsCount)")
        textLabel.font = .systemFont(ofSize: 25)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    func setLevel(level: ImpressionLevel) {
        textLabel.text = level.emoji
        detailTextLabel.text = "\(level.postsCount)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
