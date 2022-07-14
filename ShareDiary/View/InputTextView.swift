//
//  InputTextView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InputTextView: UITextView {

    private let disposeBag = DisposeBag()

    var layoutBlock: (() -> Void)?

    var placeHolder: String = "" {
        willSet {
            self.placeHolderLabel.text = newValue
            self.placeHolderLabel.sizeToFit()

        }
    }

    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = Theme.Font.getAppFont(size: 14)
        label.textColor = .gray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        setup()
        bind()
    }

    private func setup() {
        self.placeHolderLabel.alpha = 1
        placeHolderLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 7, left: 5, bottom: 7, right: 5))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBlock?()
    }

    private func bind() {
        self.rx.didBeginEditing
            .asDriver()
            .drive {[weak self]_ in
                self?.layer.borderColor = UserSettings.shared.themeDeepColor.cgColor
                self?.layer.borderWidth = 2
            }
            .disposed(by: disposeBag)

        self.rx.didEndEditing
            .asDriver()
            .drive {[weak self]_ in
                self?.layer.borderColor = UIColor.clear.cgColor
                self?.layer.borderWidth = 0
            }
            .disposed(by: disposeBag)

        self.rx.text
            .asDriver()
            .drive {[weak self]_ in
                guard let self = self else { return }
                let shouldHidden = self.placeHolder.isEmpty || !self.text.isEmpty
                self.placeHolderLabel.alpha = shouldHidden ? 0 : 1
            }
            .disposed(by: disposeBag)
    }

}
