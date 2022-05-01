//
//  SignInWithMailHelper.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import FirebaseAuth
import RxSwift
import RxCocoa

class SignInWithMailHelper {

    func signUpWithMail(emailAddress: String) -> Observable<String> {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { fatalError("cannot found bundle Identifier") }
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://sharediary.com/sign_in")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.dynamicLinkDomain = "sharediary.page.link"
        actionCodeSettings.setIOSBundleID(bundleIdentifier)

        return Observable<String>.create { observer -> Disposable in
            Auth.auth().sendSignInLink(toEmail: emailAddress,
                                       actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    observer.onNext(error.localizedDescription)
                } else {
                    observer.onNext("")
                }
            }
            return Disposables.create()
        }
    }

    func signInWithMail() {

    }

}
