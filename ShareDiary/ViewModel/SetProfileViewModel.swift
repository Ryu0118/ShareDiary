//
//  SetProfileViewModel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/02.
//
import Foundation
import RxSwift
import FirebaseAuth
import RxCocoa

protocol SetProfileViewModelInputs: AnyObject {
    var userInfo: AnyObserver<UserInfo> { get }
    var nameObserver: AnyObserver<String> { get }
    var userNameObserver: AnyObserver<String> { get }
}

protocol SetProfileViewModelOutputs: AnyObject {
    var isAuthorizationSuccessed: Driver<String> { get }
    var isValidUserInfo: Driver<[String]> { get }
}

class SetProfileViewModel: SetProfileViewModelInputs, SetProfileViewModelOutputs {

    var inputs: SetProfileViewModelInputs { self }
    var outputs: SetProfileViewModelOutputs { self }

    let authType: AuthType
    var isUserCreateRequired = true

    // inputs
    private let userInfoSubject = PublishSubject<UserInfo>()
    var userInfo: AnyObserver<UserInfo> {
        userInfoSubject.asObserver()
    }
    private let nameSubject = BehaviorSubject<String>(value: "")
    var nameObserver: AnyObserver<String> {
        nameSubject.asObserver()
    }
    private let userNameSubject = BehaviorSubject<String>(value: "")
    var userNameObserver: AnyObserver<String> {
        userNameSubject.asObserver()
    }

    // outputs
    var isAuthorizationSuccessed: Driver<String>
    var isValidUserInfo: Driver<[String]>

    init(authType: AuthType, isUserCreateRequired: Bool = true) {
        self.authType = authType
        self.isUserCreateRequired = isUserCreateRequired

        isAuthorizationSuccessed = userInfoSubject
            .flatMap { userInfo -> Observable<String> in
                if isUserCreateRequired {
                    return Authorization.shared.createUser(info: userInfo, authType: authType)
                } else {
                    if let user = Auth.auth().currentUser {
                        return Authorization.shared.setUserInfoWithImage(userInfo: userInfo, user: user)
                    } else {
                        fatalError("Current User not found")
                    }
                }
            }
            .asDriver(onErrorJustReturn: NSLocalizedString("ユーザーを作成できませんでした。最初からやり直してください", comment: ""))

        isValidUserInfo = Observable.combineLatest(nameSubject, userNameSubject)
            .map { name, userName -> ([String], String) in
                var errors = [String]()
                if !Regex.isValidText(name, limit: 15) {
                    errors.append(NSLocalizedString("名前は15文字以内で入力してください", comment: ""))
                }
                if !Regex.isValidUserName(userName) {
                    errors.append(NSLocalizedString("ユーザー名は20文字以内、英数字で入力してください", comment: ""))
                }
                return (errors, userName)
            }
            .flatMap { errors, userName -> Observable<[String]> in
                if !errors.isEmpty {
                    return Observable<[String]>.just(errors)
                } else {
                    return Authorization.shared.isValidUserId(userID: userName)
                        .map { isValidUserID in
                            return isValidUserID ? [] : [NSLocalizedString("このユーザーIDは既に使われています", comment: "")]
                        }
                }
            }
            .asDriver(onErrorJustReturn: [NSLocalizedString("エラーが発生しました", comment: "")])
    }

}
