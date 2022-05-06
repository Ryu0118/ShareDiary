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
            .drive {[weak self] _ in
                self?.handler?()
            }
            .disposed(by: disposeBag)

    }

}
