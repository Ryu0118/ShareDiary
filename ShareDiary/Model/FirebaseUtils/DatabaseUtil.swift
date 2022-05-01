//
//  DatabaseUtil.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import FirebaseDatabase
import RxSwift
import RxCocoa

class DatabaseUtil {

    static let shared = DatabaseUtil()
    private init() {}

    private let database = Database.database().reference()

    func getData(_ collection: String, path: String) -> Observable<Any> {
        Observable<Any>.create { observer -> Disposable in
            self.database.child(collection).child(path).getData { error, snapshot in
                if let error = error {
                    observer.onError(error)
                } else if let data = snapshot.value {
                    observer.onNext(data)
                } else {
                    observer.onError("Data not found")
                }
            }
            return Disposables.create()
        }
    }

    func setData(_ collection: String, path: String, data: Any) {
        self.database.child(collection).child(path).setValue(data)
    }

}
