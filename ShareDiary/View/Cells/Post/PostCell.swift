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

final class PostCell: UICollectionViewCell, InputAppliable {
    
    /*
     PostCircleDateView, impressionLabel, titleLabel
     PostImageCollectionViewController
     PostMessageView
     PostStatusView
     */
    
    var post: Post! {
        didSet {
            dateView.apply(input: .setDate(date: post.date))
        }
    }
    
    private var core = UIView()
    private var dateView = PostCircleDateView(frame: .zero)
    private var impressionLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 20)
        return label
    }()
    private var titleLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 25)
        label.textColor = UserSettings.shared.dynamicTextColor
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

    enum Input {
        case setPost(post: Post)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
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

fileprivate class PostCircleDateView: CircleView, InputAppliable {
    
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
