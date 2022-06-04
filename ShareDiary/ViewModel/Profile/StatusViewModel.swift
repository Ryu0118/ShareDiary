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
    var statuses: BehaviorRelay<[StatusSectionModel]> { get }
}

protocol StatusViewModelType: AnyObject {
    var inputs: StatusViewModelInputs { get }
    var outputs: StatusViewModelOutputs { get }
}

class StatusViewModel: StatusViewModelType, StatusViewModelInputs, StatusViewModelOutputs {

    var inputs: StatusViewModelInputs { self }
    var outputs: StatusViewModelOutputs { self }

    // outputs
    var statuses = BehaviorRelay<[StatusSectionModel]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        // mock
        let mock = Observable.of(TitlesMock.createMock())
        let postsData = Observable.of(PostsDataMock.createMock())

        Observable.combineLatest(mock, postsData)
            .map { titles, postsData -> [StatusSectionModel] in
                let titleItems = titles.map { StatusItem.title(title: $0) }
                let postsItems = [StatusItem.postsGraph(postsData: postsData)]
                let section = [StatusSectionModel(model: .titles, items: titleItems), StatusSectionModel(model: .postsGraph, items: postsItems)]
                return section
            }
            .bind(to: statuses)
            .disposed(by: disposeBag)

    }

}
