//
//  SignInWithGoogleHelper.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/03.
//

import GoogleSignIn
import Firebase
import RxSwift
import RxCocoa
import Foundation
import ProgressHUD

class SignInWithGoogleHelper: LoginComponents {

    private func showSetProfileVC(isUserCreateRequired: Bool = true, authType: AuthType) {
        let setProfileVC = SetProfileViewController(authType: authType, viewModel: SetProfileViewModel(authType: authType, isUserCreateRequired: isUserCreateRequired), isUserCreateRequired: isUserCreateRequired)
        setProfileVC.modalPresentationStyle = .fullScreen

        UIApplication.topViewController()?.present(setProfileVC, animated: true)
    }

    func signInWithGoogle() -> Observable<String> {
        Observable<(String, AuthCredential?)>.create { observer -> Disposable in
            guard let clientID = FirebaseApp.app()?.options.clientID, let topViewController = UIApplication.topViewController() else {
                observer.onNext((NSLocalizedString("clientIDが見つかりませんでした。", comment: ""), nil))
                return Disposables.create()
            }
            let config = GIDConfiguration(clientID: clientID)

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: topViewController) {user, error in
                if let error = error {
                    observer.onNext((error.localizedDescription, nil))
                    return
                }

                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    observer.onNext((NSLocalizedString("認証に失敗しました", comment: ""), nil))
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

                observer.onNext(("", credential))

            }
            return Disposables.create()
        }
        .do { _ in ProgressHUD.show() }
        .flatMap { error, credential -> Observable<String> in
            if let credential = credential, error.isEmpty {
                // エラーが空でOAuth認証が成功した時, Firebase Authでログイン
                return Authorization.shared.signIn(with: credential)
                    .flatMap { error -> Observable<String> in
                        // Firebase Authでのログインのエラーがからの時, ログインが成功してcurrentUserの値があった時
                        if error.isEmpty, let user = Auth.auth().currentUser {
                            // 既にUser Dataが作成されているかを確認する。User Dataが既に作成されていて、新規登録の必要がない時、showMainViewController
                            // 新規登録が未完了の場合、SetProfileViewControllerが呼ばれる。
                            return DatabaseUtil.shared.contains("users_uid", path: user.uid)
                                .do {[weak self] isContains in
                                    guard let self = self else { return }
                                    if isContains {
                                        self.showMainViewController()
                                    } else {
                                        self.showSetProfileVC(isUserCreateRequired: false, authType: .google(credential))
                                    }
                                }
                                // ログインに成功しているのでNon Errorを流す
                                .flatMap { _ in "".asObservable() }
                        } else {
                            return error.asObservable()
                        }
                    }
            } else {
                return error.asObservable()
            }
        }
        .do { _ in ProgressHUD.dismiss() }

    }
}
