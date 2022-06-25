//
//  GraphControlView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class YearControlView: UIView, InputAppliable {

    private let disposeBag = DisposeBag()
    let viewModel = GraphControlViewModel()
    var years = [String]() {
        didSet {
            self.updateButton()
        }
    }
    var currentIndex = 0
    var currentYear: String? {
        didSet {
            if let currentYear = currentYear {
                yearLabel.text = currentYear + NSLocalizedString("年", comment: "")
            }
        }
    }

    let yearLabel: LayoutableLabel = {
        let label = LayoutableLabel()
        label.backgroundColor = Theme.Color.appThemeColor
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layoutBlock = {
            label.layer.cornerRadius = label.frame.height / 2
        }
        return label
    }()

    var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(R.image.arrowLeft()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.tintColor = Theme.Color.appThemeColor
        button.isUserInteractionEnabled = true
        return button
    }()

    var forwardButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(R.image.arrowRight()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.tintColor = Theme.Color.appThemeColor
        button.isUserInteractionEnabled = true
        return button
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, yearLabel, forwardButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    enum Input {
        case setAllowedYears(years: [String])
    }

    init() {
        super.init(frame: .zero)
        setupViews()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        switch input {
        case .setAllowedYears(let years):
            self.years = years
            self.currentYear = years[currentIndex]
        }
    }

    private func setupViews() {
        addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        yearLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(35)
        }

        backButton.snp.makeConstraints {
            $0.width.equalTo(30)
        }

        forwardButton.snp.makeConstraints {
            $0.width.equalTo(30)
        }

    }

    private func updateButton() {
        backButton.isEnabled = years[safe: currentIndex + 1] != nil
        forwardButton.isEnabled = years[safe: currentIndex - 1] != nil
    }

    private func bind() {

        backButton.rx.tap
            .do { [weak self] _ in
                guard let self = self else { return }
                if let year = self.years[safe: self.currentIndex + 1] {
                    self.currentYear = year
                    self.currentIndex += 1
                    self.updateButton()
                }
            }
            .map { [weak self] _ in
                guard let self = self else { return 0 }
                return self.currentIndex
            }
            .bind(to: viewModel.inputs.backButtonObserver)
            .disposed(by: disposeBag)

        forwardButton.rx.tap
            .do { [weak self] _ in
                guard let self = self else { return }
                if let year = self.years[safe: self.currentIndex - 1] {
                    self.currentYear = year
                    self.currentIndex -= 1
                    self.updateButton()
                }
            }
            .map { [weak self] _ in
                guard let self = self else { return 0 }
                return self.currentIndex
            }
            .bind(to: viewModel.inputs.forwardButtonObserver)
            .disposed(by: disposeBag)

    }

}
