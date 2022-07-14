//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    // MARK: Properties

    let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private let settings = UserSettings.shared

    // required for Apple OAuth
    var currentNonce: String?
    var authenticationResponse = PublishRelay<String>()

    // required for Twitter OAuth
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
        label.text = NSLocalizedString("ログイン", comment: "")
        label.textColor = .black
        return label
    }()

    private lazy var descriptionLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 15)
        label.text = NSLocalizedString("ようこそ! WorldLifeへ\nログインして日々の出来事を日記に記そう", comment: "")
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

    private lazy var signInButton: InteractiveButton = {
        let button = InteractiveButton(frame: .zero)
        button.setTitle(NSLocalizedString("ログイン", comment: ""), for: .normal)
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
        button.setTitle(NSLocalizedString("Appleでログインする", comment: ""), for: .normal)
        return button
    }()

    private let googleButton: OAuthButton = {
        let button = OAuthButton(image: R.image.google())
        button.setTitle(NSLocalizedString("Googleでログインする", comment: ""), for: .normal)
        return button
    }()

    private let twitterButton: OAuthButton = {
        let button = OAuthButton(image: R.image.twitter())
        button.setTitle(NSLocalizedString("Twitterでログインする", comment: ""), for: .normal)
        return button
    }()

    private lazy var noAccountLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 14)
        label.text = NSLocalizedString("アカウントをお持ちでない方はこちら", comment: "")
        label.textColor = settings.textGray
        label.numberOfLines = 1
        return label
    }()

    private let newRegistrationButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("新規登録", comment: ""), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = Theme.Font.getAppFont(size: 13)
        return button
    }()

    // MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = settings.backgroundColor
        setupView()
        bind()
        // If a login flow using OAuth is interrupted in the middle of a login flow, the user must sign out to avoid problems.
        try? Auth.auth().signOut()
    }

    // MARK: setupView
    private func setupView() {
        view.addSubview(stackView)

        let views = [
            loginLabel,
            descriptionLabel,
            mailAddressField,
            passwordField,
            signInButton,
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

    // MARK: setConstraints
    private func setConstraints() {

        let sameLayoutArray = [mailAddressField, passwordField, signInButton, appleButton, googleButton, twitterButton ]

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

    // MARK: bind
    private func bind() {

        newRegistrationButton.rx.tap.asDriver()
            .drive { [weak self] _ in
                let registrationVC = RegistrationViewController()
                registrationVC.modalTransitionStyle = .flipHorizontal
                registrationVC.modalPresentationStyle = .fullScreen
                self?.present(registrationVC, animated: true, completion: nil)
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

        appleButton.rx.tap
            .asDriver()
            .drive {[weak self] _ in
                self?.requestSignInAppleFlow()
            }
            .disposed(by: disposeBag)

        authenticationResponse.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {error in
                if !error.isEmpty {
                    ProgressHUD.showFailed(error, interaction: true)
                } else {
                    print("成功しました")
                }
            })
            .disposed(by: disposeBag)

        googleButton.rx.tap
            .withUnretained(self)
            .do { strongSelf, _ in
                strongSelf.googleButton.isEnabled = false
            }
            .flatMap { strongSelf, _ -> Observable<String> in
                strongSelf.viewModel.inputs.loginWithGoogle()
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
                strongSelf.viewModel.inputs.loginWithTwitter(provider: strongSelf.provider)
            }
            .withUnretained(self)
            .subscribe(onNext: {strongSelf, error in
                strongSelf.twitterButton.isEnabled = true
                if !error.isEmpty {
                    ProgressHUD.showFailed(error)
                }
            })
            .disposed(by: disposeBag)

        signInButton.rx.tap
            .withLatestFrom(viewModel.outputs.shouldLogin)
            .observe(on: MainScheduler.instance)
            .do(onNext: { errors in
                if !errors.isEmpty {
                    let error = errors.joined(separator: "\n")
                    ProgressHUD.showFailed(error, interaction: true)
                }
            })
            .filter { $0.isEmpty }
            .withLatestFrom(
                Observable.combineLatest(
                    mailAddressField.text.orEmpty.asObservable(),
                    passwordField.text.orEmpty.asObservable()
                )
            )
            .flatMap {[weak self] email, password -> Observable<String> in
                self?.viewModel.inputs.loginWithEmail(email: email, password: password) ?? NSLocalizedString("ログインに失敗しました", comment: "").asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] error in
                if error.isEmpty {
                    self?.showMainViewController()
                } else {
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

// MARK: PreviewProvider
struct ViewControllerWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> LoginViewController {
        let vc = LoginViewController()
        return vc
    }

    func updateUIViewController(_ vc: LoginViewController, context: Context) {

    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerWrapper()
    }
}
