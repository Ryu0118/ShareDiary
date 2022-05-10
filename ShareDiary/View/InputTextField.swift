//
//  InputTextField.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InputTextField: UIView {

    var textField = InputTextFieldCore(frame: .zero)
    lazy var text: ControlProperty<String?> = textField.rx.text

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = .white
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    private func setupView() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
    }

    private func selected() {
        self.layer.borderWidth = 2
        self.layer.borderColor = Theme.Color.appThemeDeepColor.cgColor
    }

    private func unselected() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }

    private func bind() {

        textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive {[weak self]_ in
                self?.selected()
            }
            .disposed(by: disposeBag)

        textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive { [weak self] _ in
                self?.unselected()
            }
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputTextFieldCore: UITextField, UITextFieldDelegate {

    override var placeholder: String? {
        get {
            super.placeholder
        }
        set {
            let attributed = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: Theme.Color.textGray])
            self.attributedPlaceholder = attributed
            super.placeholder = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.font = Theme.Font.getAppFont(size: 15)
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
