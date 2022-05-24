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
        bind()
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

    func bind() {

        let tap = UITapGestureRecognizer()
        tap.rx.event
            .asDriver()
            .drive {[weak self] event in
                self?.handler?()
                switch event.state {
                case .began:
                    UIView.animate(withDuration: 0.1) {
                        self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }
                case .ended:
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.1, options: [.overrideInheritedCurve], animations: {
                        self?.transform = .identity
                    })
                default: break
                }
            }
            .disposed(by: disposeBag)

    }

}
