import UIKit
import SnapKit

class ProfileUserInfoView: UIView, InputAppliable {

    enum Input {
        case setProfileStyle(style: ProfileHeaderViewController.ProfileStyle)
        case setImage(image: UIImage)
        case setName(name: String)
        case setUserName(userName: String)
        case setUserIntroduction(introduction: String)
    }
    
    var profileStyle: ProfileHeaderViewController.ProfileStyle?
    
    let imageView = ProfileImageView()
    
    private let nameLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 16)
        label.textColor = Theme.Color.Dynamic.appTextColor
        return label
    }()
    
    private let userNameLabel: WorldLifeLabel = {
        let label = WorldLifeLabel(size: 13)
        label.textColor = Theme.Color.Dynamic.textGray
        return label
    }()
    
    private let introductionLabel: WorldLifeLabel = {
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
            userNameLabel.text = userName
        case .setUserIntroduction(let introduction):
            introductionLabel.text = introduction
        }
    }
    
    private func setupViews() {
        imageView.apply(input: .setImageDiameter(diameter: 50))
        
        addSubviews([
            imageView,
            nameLabel,
            userNameLabel,
            introductionLabel
        ])
        
        
    }

}

extension UIView {
    func addSubviews(_ views:[UIView]) {
        views.forEach { addSubview($0) }
    }
}
