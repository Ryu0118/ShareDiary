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

    func saveImage(path: String, image: UIImage) -> Observable<(Error?, String?)> {

        Observable<(Error?, String?)>.create {observer -> Disposable in
            guard let jpegData = image.jpegData(compressionQuality: 0.1) else {
                observer.onNext((NSLocalizedString("写真が破損しています", comment: ""), nil))
                return Disposables.create()
            }

            let ref = self.storage.child(path)

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            ref.putData(jpegData, metadata: metadata) { metadata, error in
                guard let _ = metadata else {
                    observer.onNext((NSLocalizedString("写真が破損しています", comment: ""), nil))
                    return
                }
                if let error = error {
                    observer.onNext((error, nil))
                    return
                }
                ref.downloadURL { url, error in
                    if let url = url {
                        observer.onNext((nil, url.absoluteString))
                    } else if let error = error {
                        observer.onNext((error, nil))
                    } else {
                        observer.onNext((NSLocalizedString("写真の取得に失敗しました", comment: ""), nil))
                    }
                }
            }
            return Disposables.create()
        }
    }

}
