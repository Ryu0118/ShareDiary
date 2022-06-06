//
//  ProfileFollowListViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI

class ProfileFollowListViewController: UIViewController {

    let followListView = ProfileFollowListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override func loadView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setup() {
        view.addSubview(followListView)
        followListView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 4, left: 15, bottom: 4, right: 15))
        }
    }

    private func bind() {

    }

}

struct ProfileFollowListViewControllerWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = ProfileFollowListViewController

    func makeUIViewController(context: Context) -> ProfileFollowListViewController {
        let vc = ProfileFollowListViewController()
        vc.followListView.apply(inputs: [
            .setPostCount(100),
            .setFollowCount(200),
            .setFollowerCount(300)
        ])
        return vc
    }

    func updateUIViewController(_ vc: ProfileFollowListViewController, context: Context) {

    }
}

struct ProfileFollowListViewController_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFollowListViewControllerWrapper()
    }
}
