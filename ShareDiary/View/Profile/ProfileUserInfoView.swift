import UIKit
import SDWebImage
import SnapKit
import FirebaseStorage

class ProfileUserInfoView: UIView, InputAppliable {

    enum Input {
        case setProfileStyle(style: ProfileHeaderViewController.ProfileStyle)
        case setImage(image: UIImage)
        case setName(name: String)
        case setUserName(userName: String)
        case setUserIntroduction(introduction: String)
        case setImageForURL(url: String)
    }

    var profileStyle: ProfileHeaderViewController.ProfileStyle?

    let imageView = ProfileImageView()

    lazy var nameLabel: WorldLifeLabel = {
        let label = WorldLifeLabel()
        label.font = Theme.Font.getAppBoldFont(size: 16.5)
        label.textColor = Theme.Color.Dynamic.appTextColor
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.sizeToFit()
        return label
    }()

    private lazy var userNameLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 13)
        label.textColor = Theme.Color.Dynamic.textGray
        return label
    }()

    private lazy var introductionLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 14)
        label.textColor = Theme.Color.Dynamic.appTextColor
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setProfileStyle(let style):
            profileStyle = style
        case .setImage(let image):
            imageView.apply(input: .setImage(image: image))
        case .setName(let name):
            nameLabel.text = name
        case .setUserName(let userName):
            userNameLabel.text = "@" + userName
        case .setUserIntroduction(let introduction):
            introductionLabel.text = introduction
        case .setImageForURL(let string):
            imageView.sd_setImage(with: URL(string: string))
        }
    }

    private func setupViews() {
        imageView.apply(input: .setImageDiameter(diameter: 53))

        addSubviews([
            imageView,
            nameLabel,
            userNameLabel,
            introductionLabel
        ])

        imageView.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(8)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(4)
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.right.equalTo(self.snp.right).offset(-8)// next update, will change this code
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8).priority(.high)
            $0.trailing.equalTo(nameLabel)
            $0.bottom.lessThanOrEqualTo(imageView.snp.bottom)
        }

        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        userNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        introductionLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView)
            $0.trailing.equalTo(nameLabel)
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }

    }

}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
