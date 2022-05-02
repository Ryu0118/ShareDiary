//
//  Authorization.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
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

    private func setUserInfoData(userInfo: UserInfo, user: User) {
        DatabaseUtil.shared.setData("users", path: userInfo.userID, data: [
            "uid": user.uid,
            "name": userInfo.name,
            "userID": userInfo.userID,
            "discription": userInfo.discription
        ])
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
            }

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
                    case .google:
                        fatalError()
                    case .twitter:
                        fatalError()
                    }
                    return Disposables.create()
                }

            }
    }
}
