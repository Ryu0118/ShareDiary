//
//  ProfileFollowEditViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

class ProfileFollowEditViewController: UIViewController {

    let followEditButton = ProfileFollowEditButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override func loadView() {
        super.loadView()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setup() {
        view.addSubview(followEditButton)
        followEditButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 4, left: 15, bottom: 4, right: 15))
        }
    }

    private func bind() {

    }

}

struct ProfileFollowEditViewControllerWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = ProfileFollowEditViewController

    func makeUIViewController(context: Context) -> ProfileFollowEditViewController {
        let vc = ProfileFollowEditViewController()
        vc.followEditButton.apply(input: .setProfileStyle(.otherProfile))
        return vc
    }

    func updateUIViewController(_ vc: ProfileFollowEditViewController, context: Context) {

    }
}

struct ProfileFollowEditViewController_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFollowEditViewControllerWrapper()
    }
}
