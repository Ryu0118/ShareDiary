//
//  SetProfileViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import UIKit
import FirebaseAuth
import Rswift
import RxSwift
import RxCocoa
import SnapKit
import ProgressHUD
import SDWebImage

class SetProfileViewController: UIViewController, LoginComponents {

    let authType: AuthType
    let viewModel: SetProfileViewModel

    var isUserCreateRequired: Bool

    private let imageSize: CGFloat = 150
    private let disposeBag = DisposeBag()
    private let settings = UserSettings.shared
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

    private let imageView: EditImageView = {
        let imageView = EditImageView(image: R.image.nouser())
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
        field.placeHolder = NSLocalizedString("100文字以内で入力してください (任意)", comment: "")
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
        button.backgroundColor = settings.themeColor
        button.setTitle(NSLocalizedString("新規登録", comment: ""), for: .normal)
        button.layoutBlock = {[weak introduction] in
            button.layer.cornerRadius = button.frame.height / 2
            introduction?.layer.cornerRadius = button.frame.height / 2
        }
        return button
    }()

    // MARK: Initializer
    required init(authType: AuthType, viewModel: SetProfileViewModel, isUserCreateRequired: Bool = true) {
        self.isUserCreateRequired = true
        self.authType = authType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = settings.backgroundColor
        setup()
        setDefaultValue()
        bind()
    }

}

// MARK: Methods
extension SetProfileViewController {

    private func setDefaultValue() {
        if let user = Auth.auth().currentUser {
            if let photoURL = user.photoURL {
                imageView.sd_setImage(with: photoURL, placeholderImage: R.image.nouser())
            }
            if let displayName = user.displayName {
                nameField.textField.text = displayName
            }
        }
    }

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

    private func showRegistrationViewController() {
        let registrationVC = RegistrationViewController()
        registrationVC.modalPresentationStyle = .fullScreen
        self.present(registrationVC, animated: true)
    }

    private func allDisabled() {
        [imageView, nameField, userNameField, registerButton, introduction]
            .forEach { component in
                component.isUserInteractionEnabled = false
            }
    }

    private func allEnabled() {
        [imageView, nameField, userNameField, registerButton, introduction]
            .forEach { component in
                component.isUserInteractionEnabled = true
            }
    }

    // MARK: bind
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

        imageView.croppedImage
            .asObservable()
            .observe(on: MainScheduler.instance)
            .withUnretained(imageView)
            .subscribe(onNext: { imageView, image in
                imageView.image = image
            })
            .disposed(by: disposeBag)

        nameField.text.orEmpty
            .asDriver()
            .drive(viewModel.inputs.nameObserver)
            .disposed(by: disposeBag)

        userNameField.text.orEmpty
            .asDriver()
            .drive(viewModel.inputs.userNameObserver)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .withLatestFrom(viewModel.outputs.isValidUserInfo)
            .do(onNext: {[weak self] errors in
                if !errors.isEmpty {
                    ProgressHUD.showError(errors.joined(separator: "\n"))
                } else {
                    ProgressHUD.show()
                    self?.allDisabled()
                }
            })
            .filter { $0.isEmpty }
            .withLatestFrom(
                Observable.combineLatest(
                    imageView.croppedImage.asObservable(),
                    nameField.text.orEmpty.asObservable(),
                    userNameField.text.orEmpty.asObservable(),
                    introduction.rx.text.orEmpty.asObservable()
                )
            )
            .observe(on: MainScheduler.instance)
            .map { UserInfo(name: $1, userID: $2, image: $0, discription: $3, postCount: 0) }
            .bind(to: viewModel.inputs.userInfo)
            .disposed(by: disposeBag)

        viewModel.outputs.isAuthorizationSuccessed
            .do(onNext: {[weak self] _ in
                ProgressHUD.dismiss()
                self?.allEnabled()
            })
            .drive {[weak self] response in
                guard let self = self else { return }
                if response.isEmpty {
                    self.showMainViewController()
                    Persisted.removeAuthInfo()
                } else {
                    ProgressHUD.showError(response)
                }
            }
            .disposed(by: disposeBag)

        // keyboard will hide
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

        // keyboard will show
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
