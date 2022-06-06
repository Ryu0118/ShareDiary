//
//  ProfileUserInfoViewController.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileUserInfoViewController: UIViewController {

    let userInfoView = ProfileUserInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        //        setup()
        //        bind()
    }

    override func loadView() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        view.addSubview(userInfoView)
        userInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 0, left: 4, bottom: 0, right: 4))
        }
    }

    private func bind() {

    }

}
