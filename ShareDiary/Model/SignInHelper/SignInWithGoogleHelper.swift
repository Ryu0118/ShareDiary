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

class SignInWithGoogleHelper {

    func signInWithGoogle() -> Observable<String> {
        Observable<String>.create { observer -> Disposable in
            guard let clientID = FirebaseApp.app()?.options.clientID, let topViewController = UIApplication.topViewController() else {
                observer.onNext(NSLocalizedString("clientIDが見つかりませんでした。", comment: ""))
                return Disposables.create()
            }
            let config = GIDConfiguration(clientID: clientID)

            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: topViewController) {user, error in
                if let error = error {
                    observer.onNext(error.localizedDescription)
                    return
                }

                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    observer.onNext(NSLocalizedString("認証に失敗しました", comment: ""))
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

                observer.onNext("")
                let authType: AuthType = .google(credential)

                let setProfileVC = SetProfileViewController(authType: authType, viewModel: SetProfileViewModel(authType: authType))
                setProfileVC.modalPresentationStyle = .fullScreen
                topViewController.present(setProfileVC, animated: true)

            }
            return Disposables.create()
        }
    }

}
