//
//  Navigationable.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/25.
//

import UIKit

@objc protocol Navigationable where Self: UIViewController {
    @objc optional var leftBarButton: UIBarButtonItem! { get set }
    @objc optional var rightBarButton: UIBarButtonItem! { get set }
    @objc optional func dismissController()
}

extension Navigationable {

    func setupNavigationBar(title: String) {
        self.navigationItem.title = title
        // self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }

}
