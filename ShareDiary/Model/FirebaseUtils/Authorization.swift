//
//  Authorization.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GoogleSignIn
import RxSwift
import RxCocoa
import UIKit

class Authorization {

    static let shared = Authorization()
    private init() {}

    func isValidUserId(userID: String) -> Observable<Bool> {
        DatabaseUtil.shared.contains("users", path: userID).map { !$0 }
            .catch {_ in
                return Observable<Bool>.just(false)
            }
    }

    func isAlreadyUsedEmail(email: String) -> Observable<Bool> {
        Observable<Bool>.create { observer -> Disposable in
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { methods, error in
                if error != nil {
                    observer.onNext(false)
                } else if let methods = methods, !methods.isEmpty {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            })
            return Disposables.create()
        }
    }

    func signIn(with appleIDCredential: AuthCredential) -> Observable<String> {
        Observable<String>.create { observer -> Disposable in
            Auth.auth().signIn(with: appleIDCredential) {result, error in
                if let error = error {
                    observer.onNext(error.localizedDescription)
                } else if let _ = result?.user {
                    observer.onNext("")
                } else {
                    observer.onNext(NSLocalizedString("ログインに失敗しました", comment: ""))
                }
            }
            return Disposables.create()
        }
    }

    func setUserInfoData(userInfo: UserInfo, user: User) {
        DatabaseUtil.shared.setData("users", path: userInfo.userID, data: [
            "uid": user.uid,
            "name": userInfo.name,
            "userID": userInfo.userID,
            "discription": userInfo.discription
        ])
        DatabaseUtil.shared.setData("users_uid", path: user.uid, data: [
            "userID": userInfo.userID
        ])
    }

    func setUserInfoWithImage(userInfo: UserInfo, user: User) -> Observable<String> {
        StorageUtil.shared.saveImage(path: "users/\(userInfo.userID).jpg", image: userInfo.image)
            .flatMap { storageError -> Observable<String> in
                if storageError.isEmpty {
                    self.setUserInfoData(userInfo: userInfo, user: user)
                    return "".asObservable()
                } else {
                    return storageError.asObservable()
                }
            }

    }

    private func createWithEmail(userInfo: UserInfo, observer: AnyObserver<String>) {
        let (email, password) = (Persisted.auth.email, Persisted.auth.password)
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                observer.onNext(error.localizedDescription)
            } else if let user = result?.user {
                self.setUserInfoData(userInfo: userInfo, user: user)
                observer.onNext("")
            } else {
                observer.onNext(NSLocalizedString("認証に失敗しました", comment: ""))
            }
        }
    }

    private func createWithApple(credential: OAuthCredential, userInfo: UserInfo, observer: AnyObserver<String>) {
        Auth.auth().signIn(with: credential) {[weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                observer.onNext(error.localizedDescription)
            } else if let user = result?.user {
                self.setUserInfoData(userInfo: userInfo, user: user)
                observer.onNext("")
            } else {
                observer.onNext(NSLocalizedString("認証に失敗しました", comment: ""))
            }
        }
    }

    private func createWithGoogle(credential: AuthCredential, userInfo: UserInfo, observer: AnyObserver<String>) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                observer.onNext(error.localizedDescription)
            } else if let user = authResult?.user {
                self.setUserInfoData(userInfo: userInfo, user: user)
                observer.onNext("")
            } else {
                observer.onNext(NSLocalizedString("認証に失敗しました", comment: ""))
            }
        }

    }

    func signIn(email: String, password: String) -> Observable<String> {
        Observable<String>.create { observer -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) {result, error in
                if let error = error {
                    observer.onNext(error.localizedDescription)
                } else if let _ = result {
                    observer.onNext("")
                } else {
                    observer.onNext(NSLocalizedString("ログインに失敗しました。", comment: ""))
                }
            }
            return Disposables.create()
        }
    }

    func createUser(info: UserInfo, authType: AuthType) -> Observable<String> {
        // save user image
        return StorageUtil.shared.saveImage(path: "users/\(info.userID).jpg", image: info.image)
            .flatMap { storageError -> Observable<String> in
                if !storageError.isEmpty {
                    return storageError.asObservable()
                }
                return Observable<String>.create { observer -> Disposable in
                    switch authType {
                    case .email:
                        self.createWithEmail(userInfo: info, observer: observer)
                    case .apple(let credential):
                        self.createWithApple(credential: credential, userInfo: info, observer: observer)
                    case .google(let credential):
                        self.createWithGoogle(credential: credential, userInfo: info, observer: observer)
                    case .twitter:
                        fatalError()
                    }
                    return Disposables.create()
                }

            }
    }
}

extension UIAlertController {

}
