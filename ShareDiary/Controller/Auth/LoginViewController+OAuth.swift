//
//  LoginViewController+OAuth.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import Foundation
import CryptoKit
import AuthenticationServices
import RxSwift
import RxCocoa
import FirebaseAuth
import ProgressHUD

// Cannot write to ViewModel Because UIViewController can only be Authentication Delegate
extension LoginViewController: LoginComponents {

    func requestSignInAppleFlow() {
        let nonce = CryptUtil.randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptUtil.sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// Cannot write to ViewModel Because UIViewController can only be Authentication Delegate
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handle(authorization.credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authenticationResponse.accept(NSLocalizedString("認証がキャンセルされました。再度ログインしてください。", comment: ""))
    }

    func handle(_ credential: ASAuthorizationCredential) {
        guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
            authenticationResponse.accept(NSLocalizedString("エラーが発生しました。再度ログインしてください。", comment: ""))
            return
        }
        guard let nonce = self.currentNonce else {
            authenticationResponse.accept("リクエストの送信に失敗しました。再度ログインしてください。")
            return
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            authenticationResponse.accept("Json Web Tokenの取得に失敗しました")
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            authenticationResponse.accept("シリアライズに失敗しました。")
            return
        }

        let oAuthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce)

        self.navigationController?.popViewController(animated: true)

        let authType: AuthType = .apple(oAuthCredential)

        // Display MainViewController
        func showSetProfileVC(isUserCreateRequired: Bool = true) {
            let setProfileVC = SetProfileViewController(authType: authType, viewModel: SetProfileViewModel(authType: authType, isUserCreateRequired: isUserCreateRequired), isUserCreateRequired: isUserCreateRequired)
            setProfileVC.modalPresentationStyle = .fullScreen

            UIApplication.topViewController()?.present(setProfileVC, animated: true)
        }

        if let _ = appleIDCredential.email {
            // On the 1st login
            showSetProfileVC()
        } else { // After the second Login Request
            Authorization.shared.signIn(with: oAuthCredential)
                .do { _ in ProgressHUD.show() }
                .subscribe(onNext: {[weak self] error in
                    guard let self = self else { return }
                    // if error does not exist, if uid is nil
                    if error.isEmpty, let user = Auth.auth().currentUser {
                        // If users_uid/uid does not exist at the second login, set Profile.
                        // If it exists, log in
                        DatabaseUtil.shared.contains("users_uid", path: user.uid)
                            .catch { _ -> Observable<Bool> in
                                return Observable<Bool>.just(false)
                            }
                            .do { _ in ProgressHUD.dismiss() }
                            .subscribe(onNext: { isContains in
                                if isContains {
                                    self.showMainViewController()
                                } else {
                                    // If profile was not set
                                    showSetProfileVC(isUserCreateRequired: false)
                                }
                            })
                            .disposed(by: self.disposeBag)

                    } else {
                        // When Sign in fails
                        ProgressHUD.dismiss()
                        self.authenticationResponse.accept(error)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
