//
//  InteractiveButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import RxCocoa
import RxSwift

class InteractiveButton: UIButton {

    private let disposeBag = DisposeBag()

    var layoutBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 10
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = Theme.Font.getAppFont(size: 16)

        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBlock?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {

        self.rx.controlEvent(.touchDown).asDriver()
            .drive {[weak self] _ in
                UIView.animate(withDuration: 0.1) {
                    self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            }
            .disposed(by: disposeBag)

        self.rx.controlEvent([.touchUpInside, .touchUpOutside]).asDriver(onErrorJustReturn: ())
            .drive {[weak self] _ in
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [.overrideInheritedCurve], animations: {
                    self?.transform = .identity
                })
            }
            .disposed(by: disposeBag)

    }

}
