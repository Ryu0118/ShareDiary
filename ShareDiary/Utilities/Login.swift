//
//  Login.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit

protocol LoginComponents {}

extension LoginComponents {
    func showMainViewController() {
        let main = MainViewController()
        main.modalPresentationStyle = .fullScreen

        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        window?.rootViewController = main
        window?.makeKeyAndVisible()
    }
}
