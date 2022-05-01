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

struct UserInfo {
    let authorizationInfo: AuthorizationInfo
    let name: String
    let userID: String// @abcdef
    let image: UIImage?
    let discription: String
}

class Authorization {

    static let shared = Authorization()
    private init() {}

    func createUser(info: UserInfo) -> Observable<String> {
        let (email, password) = (info.authorizationInfo.email, info.authorizationInfo.password)
        return Observable<String>.create { observer -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    observer.onNext(error.localizedDescription)
                } else if let user = result?.user {
                    DatabaseUtil.shared.setData("users", path: user.uid, data: [
                        "uid": user.uid,
                        "name": info.name,
                        "userID": info.userID,
                        "image": info.image as Any,
                        "discription": info.discription
                    ]
                    )
                    observer.onNext("")
                }
            }

            return Disposables.create()
        }
    }
}
