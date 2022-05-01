//
//  SetProfileViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import UIKit
import Rswift
import RxSwift
import RxCocoa
import SnapKit

class SetProfileViewController: UIViewController {

    private let imageSize: CGFloat = 150
    private let disposeBag = DisposeBag()

    private lazy var originHeight = self.view.frame.origin.y

    private let stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    private let profileLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 26)
        label.text = NSLocalizedString("プロフィールを設定しよう", comment: "")
        label.textColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.nouser())
        return imageView
    }()

    private let nameDescription: WorldLifeLabel = {
        let nameLabel = WorldLifeLabel(size: 13)
        nameLabel.text = NSLocalizedString("・名前", comment: "")
        nameLabel.font = Theme.Font.getAppBoldFont(size: 13)
        nameLabel.textColor = .black
        return nameLabel
    }()

    private let nameField: InputTextField = {
        let field = InputTextField(frame: .zero)
        field.textField.placeholder = NSLocalizedString("15文字以内で名前を入力してください", comment: "")
        field.textField.keyboardType = .default
        return field
    }()

    private let userNameDescription: WorldLifeLabel = {
        let nameLabel = WorldLifeLabel(size: 13)
        nameLabel.text = NSLocalizedString("・ユーザー名", comment: "")
        nameLabel.font = Theme.Font.getAppBoldFont(size: 13)
        nameLabel.textColor = .black
        return nameLabel
    }()

    private let userNameField: InputTextField = {
        let field = InputTextField(frame: .zero)
        field.textField.placeholder = NSLocalizedString("20文字以内、英数字で入力してください", comment: "")
        field.textField.keyboardType = .alphabet
        return field
    }()

    private let introductionDescription: WorldLifeLabel = {
        let nameLabel = WorldLifeLabel(size: 13)
        nameLabel.text = NSLocalizedString("・自己紹介", comment: "")
        nameLabel.font = Theme.Font.getAppBoldFont(size: 13)
        nameLabel.textColor = .black
        return nameLabel
    }()

    private let introduction: InputTextView = {
        let field = InputTextView(frame: .zero)
        field.font = Theme.Font.getAppFont(size: 14)
        field.placeHolder = NSLocalizedString("100文字以内で入力してください", comment: "")
        field.text = "自己紹介"
        field.text = ""
        field.layoutBlock = {
            field.contentInset.left = 10
            field.contentInset.right = 10
        }
        return field
    }()

    private lazy var registerButton: InteractiveButton = {
        let button = InteractiveButton(frame: .zero)
        button.backgroundColor = Theme.Color.appThemeColor
        button.setTitle(NSLocalizedString("新規登録", comment: ""), for: .normal)
        button.layoutBlock = {[weak introduction] in
            button.layer.cornerRadius = button.frame.height / 2
            introduction?.layer.cornerRadius = button.frame.height / 2
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.appBackgroundColor
        setup()
        bind()
    }

}

// MARK: Methods
extension SetProfileViewController {

    private func setup() {
        view.addSubview(stackView)

        let views = [
            profileLabel,
            imageView,
            nameDescription,
            nameField,
            userNameDescription,
            userNameField,
            introductionDescription,
            introduction,
            registerButton
        ]
        let spaces: [CGFloat] = [
            25,
            25,
            4,
            12,
            4,
            12,
            4,
            30,
            0
        ]

        stackView.addArrangedSubviews(views)

        setConstraints()

        zip(views, spaces).forEach { component, space in
            stackView.setCustomSpacing(space, after: component)
        }

    }

    private func setConstraints() {

        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }

        profileLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
        }

        nameField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.equalTo(50)
        }

        userNameField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.equalTo(50)
        }

        introduction.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.equalTo(100)
        }

        nameDescription.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.83)
            $0.height.equalTo(15)
        }

        userNameDescription.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.83)
            $0.height.equalTo(15)
        }

        introductionDescription.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.83)
            $0.height.equalTo(15)
        }

        registerButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.height.equalTo(50)
        }

    }

    private func bind() {

        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.asDriver()
            .drive {[weak self]_ in
                self?.nameField.resignFirstResponder()
                self?.userNameField.resignFirstResponder()
                self?.introduction.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .asDriver(onErrorJustReturn: 0)
            .drive {[weak self] height in
                guard let self = self else { return }
                guard self.view.frame.origin.y != 0 else { return }

                self.view.frame.origin.y += height / 2
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .asDriver(onErrorJustReturn: 0)
            .drive {[weak self] height in
                guard let self = self else { return }
                var originalHeight = self.originHeight
                originalHeight -= height / 2
                self.view.frame.origin.y = originalHeight
            }
            .disposed(by: disposeBag)

    }

}