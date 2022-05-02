//
//  EditImageView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import CropViewController
import Rswift
import SnapKit

class EditImageView: UIImageView {

    private var disposeBag = DisposeBag()

    var croppedImage = BehaviorRelay<UIImage>(value: R.image.nouser() ?? UIImage())

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        self.isUserInteractionEnabled = true
    }

    override init(image: UIImage?) {
        super.init(image: image)
        bind()
        setup()
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

    private func setup() {
        // path-through
    }

    private func bind() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event
            .asDriver()
            .drive {[weak self]_ in
                let alubum = UIAlertController.Actions(title: NSLocalizedString("アルバムから選択する", comment: ""), handler: {
                    self?.presentPickerViewController()
                })
                let take = UIAlertController.Actions(title: NSLocalizedString("写真を撮る", comment: ""), handler: {
                    self?.presentCameraViewController()
                })
                let cancel = UIAlertController.Actions(title: NSLocalizedString("キャンセル", comment: ""), isCancel: true)
                UIAlertController.sheet(title: NSLocalizedString("プロフィール画像を変更する", comment: ""), message: "", actions: [alubum, take, cancel])
            }
            .disposed(by: disposeBag)

        self.addGestureRecognizer(tapGestureRecognizer)

    }

    private func presentPickerViewController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        UIApplication.topViewController()?.present(imagePicker, animated: true)
    }

    private func presentCameraViewController() {
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = sourceType
            cameraViewController.delegate = self
            UIApplication.topViewController()?.present(cameraViewController, animated: true)
        }
    }

}

extension EditImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let pickedImage = info[.originalImage]
            as? UIImage {
            let cropViewController = CropViewController(croppingStyle: .circular, image: pickedImage)
            cropViewController.delegate = self
            imagePicker.pushViewController(cropViewController, animated: true)

        } else {
            // did failed
            imagePicker.dismiss(animated: true, completion: nil)
        }

    }

}

extension EditImageView: CropViewControllerDelegate {

    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // UIImage to stream
        croppedImage.accept(image)
        cropViewController.dismiss(animated: true)
    }

}

extension UIAlertController {

    struct Actions {
        var title: String?
        var isCancel = false
        var handler: (() -> Void)?

        init(title: String? = nil, isCancel: Bool = false, handler: (() -> Void)? = nil) {
            self.title = title
            self.isCancel = isCancel
            self.handler = handler
        }
    }

    static func sheet(title: String, message: String, actions: [Actions]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.isCancel ? .cancel : .default, handler: {_ in
                action.handler?()
                alert.dismiss(animated: true)
            })
            alert.addAction(alertAction)
        }
        UIApplication.topViewController()?.present(alert, animated: true)
    }

}
