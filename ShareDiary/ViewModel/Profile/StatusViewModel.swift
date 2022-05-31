//
//  StatusViewModel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/28.
//

import RxSwift
import RxCocoa

protocol StatusViewModelInputs: AnyObject {

}

protocol StatusViewModelOutputs: AnyObject {
    var titles: BehaviorRelay<[StatusSectionModel]> { get }
}

protocol StatusViewModelType: AnyObject {
    var inputs: StatusViewModelInputs { get }
    var outputs: StatusViewModelOutputs { get }
}

class StatusViewModel: StatusViewModelType, StatusViewModelInputs, StatusViewModelOutputs {

    var inputs: StatusViewModelInputs { self }
    var outputs: StatusViewModelOutputs { self }

    // outputs
    var titles = BehaviorRelay<[StatusSectionModel]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        // mock
        Observable.of(
            TitlesMock.createMock()
        )
        .map { titles -> [StatusSectionModel] in
            let items = titles.map { StatusItem.title(title: $0) }
            let section = [StatusSectionModel(model: .titles, items: items)]
            return section
        }
        .bind(to: titles)
        .disposed(by: disposeBag)
    }

}
