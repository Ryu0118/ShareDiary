//
//  RegistrationViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import SnapKit
import RxSwift
import Rswift
import RxCocoa
import FirebaseAuth
import SwiftUI
import ProgressHUD

class RegistrationViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let viewModel = RegistrationViewModel()
    private let settings = UserSettings.shared

    // Required for apple authentication
    var currentNonce: String?
    var authenticationResponse = PublishRelay<String>()

    // Required for twitter authentication
    var provider = OAuthProvider(providerID: "twitter.com")

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    private let hstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 9
        return stack
    }()

    private let loginLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 30)
        label.text = NSLocalizedString("サインアップ", comment: "")
        label.textColor = .black
        return label
    }()

    private lazy var descriptionLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 15)
        label.text = NSLocalizedString("ようこそ! WorldLifeへ\nサインアップして日々の出来事を日記に記そう", comment: "")
        label.textColor = settings.textGray
        return label
    }()

    private let mailAddressField: InputTextField = {
        let field = InputTextField(frame: .zero)
        field.textField.placeholder = NSLocalizedString("メールアドレス", comment: "")
        field.textField.keyboardType = .emailAddress
        return field
    }()

    private let passwordField: InputTextField = {
        let field = InputTextField(frame: .zero)
        field.textField.placeholder = NSLocalizedString("パスワード", comment: "")
        field.textField.keyboardType = .default
        field.textField.isSecureTextEntry = true
        return field
    }()

    private lazy var signUpButton: InteractiveButton = {
        let button = InteractiveButton(frame: .zero)
        button.setTitle(NSLocalizedString("新規登録", comment: ""), for: .normal)
        button.backgroundColor = settings.themeColor
        button.layoutBlock = {
            button.layer.cornerRadius = button.frame.height / 2
        }
        return button
    }()

    private lazy var orLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 14)
        label.text = NSLocalizedString("または", comment: "")
        label.textColor = settings.textGray
        label.textAlignment = .center
        return label
    }()

    private let appleButton: OAuthButton = {
        let button = OAuthButton(image: R.image.apple())
        button.setTitle(NSLocalizedString("Appleで新規登録する", comment: ""), for: .normal)
        return button
    }()

    private let googleButton: OAuthButton = {
        let button = OAuthButton(image: R.image.google())
        button.setTitle(NSLocalizedString("Googleで新規登録する", comment: ""), for: .normal)
        return button
    }()

    private let twitterButton: OAuthButton = {
        let button = OAuthButton(image: R.image.twitter())
        button.setTitle(NSLocalizedString("Twitterで新規登録する", comment: ""), for: .normal)
        return button
    }()

    private lazy var noAccountLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 14)
        label.text = NSLocalizedString("アカウントをお持ちの方はこちら", comment: "")
        label.textColor = settings.textGray
        label.numberOfLines = 1
        return label
    }()

    private let newRegistrationButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("ログイン", comment: ""), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = Theme.Font.getAppFont(size: 13)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = settings.backgroundColor
        setupView()
        bind()
        // If a login flow using OAuth is interrupted in the middle of a login flow, the user must sign out to avoid problems.
        try? Auth.auth().signOut()
    }

    private func setupView() {
        view.addSubview(stackView)

        let views = [
            loginLabel,
            descriptionLabel,
            mailAddressField,
            passwordField,
            signUpButton,
            orLabel,
            appleButton,
            googleButton,
            twitterButton,
            hstack
        ]
        let spacings: [CGFloat] = [
            2,
            20,
            12,
            28,
            14,
            14,
            15,
            15,
            18,
            0
        ]

        stackView.addArrangedSubviews(views)
        hstack.addArrangedSubviews([noAccountLabel, newRegistrationButton])

        setConstraints()

        zip(views, spacings).forEach { component, space in
            stackView.setCustomSpacing(space, after: component)
        }
    }

    private func setConstraints() {

        let sameLayoutArray = [mailAddressField, passwordField, signUpButton, appleButton, googleButton, twitterButton ]

        stackView.snp.makeConstraints {
            // $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview()
        }

        loginLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
        }

        descriptionLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.85)
        }

        orLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }

        noAccountLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }

        sameLayoutArray.forEach { arrangedView in
            arrangedView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.8)
                $0.height.equalTo(50)
            }
        }

    }

    private func bind() {

        newRegistrationButton.rx.tap.asDriver()
            .drive { [weak self] _ in
                let loginVC = LoginViewController()
                loginVC.modalTransitionStyle = .flipHorizontal
                loginVC.modalPresentationStyle = .fullScreen
                self?.present(loginVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        mailAddressField.text.orEmpty
            .asDriver()
            .drive(viewModel.inputs.emailObserver)
            .disposed(by: disposeBag)

        passwordField.text.orEmpty
            .asDriver()
            .drive(viewModel.inputs.passwordObserver)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .withLatestFrom(viewModel.outputs.shouldLogin)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .do { _, errors in
                if !errors.isEmpty {
                    let error = errors.joined(separator: "\n")
                    ProgressHUD.showFailed(error)
                } else {
                    ProgressHUD.show()
                }
            }
            .filter { $1.isEmpty }
            .flatMap { strongSelf, _ in
                return strongSelf.viewModel.registerWithEmail(
                    email: strongSelf.mailAddressField.textField.text ?? "",
                    password: strongSelf.passwordField.textField.text ?? ""
                )
            }
            .subscribe(onNext: { error in
                if error.isEmpty {
                    ProgressHUD.showSuccess(NSLocalizedString("メールを送信しました。", comment: ""))
                } else {
                    ProgressHUD.showFailed(error)
                }
            })
            .disposed(by: disposeBag)

        appleButton.rx.tap
            .withUnretained(self)
            .subscribe { strongSelf, _ in
                strongSelf.requestSignInAppleFlow()
            }
            .disposed(by: disposeBag)

        googleButton.rx.tap
            .withUnretained(self)
            .do { strongSelf, _ in
                strongSelf.googleButton.isEnabled = false
            }
            .flatMap { strongSelf, _ -> Observable<String> in
                strongSelf.viewModel.inputs.registerWithGoogle()
            }
            .withUnretained(self)
            .subscribe(onNext: {strongSelf, error in
                strongSelf.googleButton.isEnabled = true
                if !error.isEmpty {
                    ProgressHUD.showFailed(error, interaction: true)
                }
            })
            .disposed(by: disposeBag)

        twitterButton.rx.tap
            .withUnretained(self)
            .do { strongSelf, _ in
                strongSelf.twitterButton.isEnabled = false
            }
            .flatMap { strongSelf, _ -> Observable<String> in
                strongSelf.viewModel.inputs.registerWithTwitter(provider: strongSelf.provider)
            }
            .withUnretained(self)
            .subscribe(onNext: {strongSelf, error in
                strongSelf.twitterButton.isEnabled = true
                if !error.isEmpty {
                    ProgressHUD.showFailed(error, interaction: true)
                }
            })
            .disposed(by: disposeBag)

        authenticationResponse.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {error in
                if !error.isEmpty {
                    ProgressHUD.showFailed(error, interaction: true)
                }
            })
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event
            .asDriver()
            .drive { [weak self] _ in
                self?.mailAddressField.resignFirstResponder()
                self?.passwordField.resignFirstResponder()
            }
            .disposed(by: disposeBag)

        view.addGestureRecognizer(tapGesture)
    }

}

struct RegistrationViewControllerPreview: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> RegistrationViewController {
        let vc = RegistrationViewController()
        return vc
    }

    func updateUIViewController(_ vc: RegistrationViewController, context: Context) {

    }
}

struct RegistrationViewController_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationViewControllerPreview()
    }
}
