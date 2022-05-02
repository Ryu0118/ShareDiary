//
//  StorageUtil.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import FirebaseStorage
import RxSwift
import RxCocoa
import UIKit

class StorageUtil {

    static let shared = StorageUtil()

    private let storage = Storage.storage().reference()

    private init() {}

    func saveImage(path: String, image: UIImage) -> Observable<String> {

        Observable<String>.create {observer -> Disposable in
            guard let jpegData = image.jpegData(compressionQuality: 0.1) else {
                observer.onNext(NSLocalizedString("写真が破損しています", comment: ""))
                return Disposables.create()
            }

            let ref = self.storage.child(path)

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            ref.putData(jpegData, metadata: metadata) { metadata, error in
                guard let _ = metadata else {
                    observer.onNext(NSLocalizedString("写真が破損しています", comment: ""))
                    return
                }
                if let error = error {
                    observer.onNext(error.localizedDescription)
                    return
                }
                observer.onNext("")
            }
            return Disposables.create()
        }
    }

}
