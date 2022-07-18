//
//  PostCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Lottie

final class PostCell: UICollectionViewCell, InputAppliable, CellIdentifiable {

    /*
     PostCircleDateView, impressionLabel, titleLabel
     PostImageCollectionViewController
     PostMessageView
     PostStatusView
     */

    var post: Post! {
        didSet {
            dateView.apply(input: .setDate(date: post.date))
            postImageViewController.apply(input: .setImageURLs(urls: post.imageURLs))
            impressionLabel.text = post.impressionString
        }
    }

    private let core = UIView()
    private let dateView = PostCircleDateView(frame: .zero)
    private let impressionLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 20)
        return label
    }()
    private let titleLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 25)
        label.textColor = UserSettings.shared.dynamicTextColor
        return label
    }()
    private let postImageViewController = PostImageCollectionViewController()
    private let messageView: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = Theme.Font.getAppFont(size: 16)
        return label
    }()
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [impressionLabel, titleLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 6
        stack.alignment = .lastBaseline
        return stack
    }()
    private lazy var stackView: UIStackView = {
        let top = UIApplication.topViewController()
        postImageViewController.didMove(toParent: top)
        let stack = UIStackView(arrangedSubviews: [titleStackView, postImageViewController.view])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 8
        top?.addChild(postImageViewController)
        return stack
    }()

    enum Input {
        case setPost(post: Post)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setPost(let post):
            self.post = post
        }
    }

}

extension PostCell {

    private func setupViews() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
    }

}

private class PostStatusView: InputAppliable {
    
    enum Input {
        case setCommentCount(count: Int)
        case setGoodCount(count: Int)
    }
    
    var commentCount = 0 {
        didSet {
            
        }
    }
    
    var goodCount = 0 {
        didSet {
            
        }
    }
    
    var goodButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: <#T##[UIView]#>)
    }()
    
    func apply(input: Input) {
        switch input {
        case .setCommentCount(let count):
            commentCount = count
        case .setGoodCount(let count):
            goodCount = count
        }
    }
    
}

private class PostCircleDateView: CircleView, InputAppliable {

    enum Input {
        case setDate(date: Date)
    }

    var date: Date! {
        didSet {
            dateLabel.text = date.getDate().toString()
        }
    }

    private var dateLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 16)
        label.textColor = UserSettings.shared.dynamicTextColor
        label.textAlignment = .center
        return label
    }()

    private var unitLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppFont(size: 13)
        label.textColor = UserSettings.shared.dynamicTextGray
        label.text = "日"
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, unitLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .bottom
        stack.spacing = 3
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setDate(let date):
            self.date = date
        }
    }

    private func setup() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
