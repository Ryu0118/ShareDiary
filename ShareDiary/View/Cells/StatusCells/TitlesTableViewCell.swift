//
//  TitlesTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/26.
//

import UIKit
import SnapKit

struct Title {
    struct Term {
        let grade: TitleCard.Grade
        let termName: String
        let isAchieved: Bool
    }
    let titleName: String
    let terms: [Term]
}

class TitlesTableViewCell: UITableViewCell, InputAppliable {

    static let identifier = "TitlesTableViewCell"

    enum Input {
        case setTitle(title: Title)
    }

    private var titleLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 16)
        label.textAlignment = .left
        return label
    }()

    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    private var vstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private var cards = [TitleCard]() {
        didSet {
            stackView.removeAllArrangedSubviews()
            stackView.addArrangedSubviews(cards)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        isUserInteractionEnabled = true
        addSubview(vstack)
        vstack.addArrangedSubviews([titleLabel, stackView])

        vstack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(ConstraintInsets(top: 4, left: 4, bottom: 4, right: 0))
        }

        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(65)
        }

        titleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(60)
            $0.height.equalTo(20)
        }
    }

    func apply(input: Input) {
        switch input {
        case .setTitle(let title):
            titleLabel.text = "・" + title.titleName
            cards = title.terms.sorted { $0.grade.rawValue > $1.grade.rawValue }.map { term in
                let card = TitleCard()
                card.apply(inputs: [
                    .setGrade(grade: term.grade),
                    .setTitleName(titleName: term.termName),
                    .setIsAchieved(isAchieved: term.isAchieved)
                ])
                return card
            }
        }
    }

}

class TitleCard: UIView, InputAppliable {

    enum Grade: Int {
        case gold = 0
        case silver = 1
        case bronze = 2
    }

    enum Input {
        case setTitleName(titleName: String)
        case setGrade(grade: Grade)
        case setIsAchieved(isAchieved: Bool)
    }

    private var imageView = UIImageView(frame: .zero)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Font.getAppFont(size: 14)
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    init() {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
    }

    func apply(input: Input) {
        switch input {
        case .setGrade(let grade):
            imageView.image = {() -> UIImage? in
                switch grade {
                case .gold:
                    return R.image.goldMedal()?.resize(scale: 0.5)
                case .bronze:
                    return R.image.bronzeMedal()?.resize(scale: 0.5)
                case .silver:
                    return R.image.silverMedal()?.resize(scale: 0.5)
                }
            }()
            let aspect = (imageView.image?.size.height ?? 0) / (imageView.image?.size.width ?? 1)
            imageView.contentMode = .scaleAspectFill
            imageView.sizeToFit()

            imageView.snp.makeConstraints {
                $0.width.lessThanOrEqualTo(60)
                $0.height.lessThanOrEqualTo(60 * aspect)
            }
            titleLabel.snp.makeConstraints {
                $0.centerX.equalTo(imageView)
                $0.width.equalToSuperview()
                $0.height.equalTo(18)
            }
        case .setTitleName(let titleName):
            titleLabel.text = titleName
        case .setIsAchieved(let isAchieved):
            if !isAchieved {
                imageView.image = R.image.secretMedal()?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = Theme.Color.Dynamic.textGray
                titleLabel.textColor = Theme.Color.Dynamic.textGray
            }
        }
    }

    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubviews([imageView, titleLabel])
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
