import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InteractiveImageView: UIImageView, InputAppliable {

    enum Input {
        case setImage(image: UIImage)
        case setTappedHandler(handler: () -> Void)
    }

    var handler: (() -> Void)?
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setImage(let image):
            self.image = image
        case .setTappedHandler(let handler):
            self.handler = handler
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handler?()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [.overrideInheritedCurve], animations: {
            self.transform = .identity
        })
    }

}
