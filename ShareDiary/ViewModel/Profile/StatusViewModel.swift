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
            [Title(
                titleName: "連続投稿",
                terms: [
                    Title.Term(grade: .gold,
                               termName: "一年",
                               isAchieved: true),
                    Title.Term(grade: .silver,
                               termName: "一ヶ月",
                               isAchieved: true),
                    Title.Term(grade: .bronze,
                               termName: "一週間",
                               isAchieved: true)
                ]
            ),
            Title(
                titleName: "投稿数",
                terms: [
                    Title.Term(grade: .gold,
                               termName: "500",
                               isAchieved: true),
                    Title.Term(grade: .silver,
                               termName: "100",
                               isAchieved: true),
                    Title.Term(grade: .bronze,
                               termName: "10",
                               isAchieved: true)
                ]
            ),
            Title(
                titleName: "課金",
                terms: [
                    Title.Term(grade: .gold,
                               termName: "一年",
                               isAchieved: false),
                    Title.Term(grade: .silver,
                               termName: "半年",
                               isAchieved: true),
                    Title.Term(grade: .bronze,
                               termName: "一ヶ月",
                               isAchieved: true)
                ]
            )
            ]
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
