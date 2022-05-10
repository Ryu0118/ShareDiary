//
//  UIImage.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit

extension UIImage {

    func resize(size: CGSize) -> UIImage? {
        let widthRatio = size.width / size.width
        let heightRatio = size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

    func changeResolution(rate: CGFloat) -> UIImage? {
        let originSize = self.size
        let height = originSize.height * rate
        let width = originSize.width * rate
        return self.resize(size: CGSize(width: width, height: height))
    }

    var iconSize: UIImage? {
        resize(size: CGSize(width: 25, height: 25))
    }

}
