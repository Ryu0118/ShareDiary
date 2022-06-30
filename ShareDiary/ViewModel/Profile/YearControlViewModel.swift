//
//  GraphControlViewModel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/02.
//

import RxSwift
import RxCocoa

protocol GraphControlViewModelInputs: AnyObject {
    var backButtonObserver: PublishRelay<Int> { get }
    var forwardButtonObserver: PublishRelay<Int> { get }
}

protocol GraphControlViewModelOutputs: AnyObject {
    var backButtonDidPressed: Driver<Int> { get }
    var forwardButtonDidPressed: Driver<Int> { get }
}

protocol GraphControlViewModelType: AnyObject {
    var inputs: GraphControlViewModelInputs { get }
    var outputs: GraphControlViewModelOutputs { get }
}

class YearControlViewModel: GraphControlViewModelType, GraphControlViewModelInputs, GraphControlViewModelOutputs {

    var inputs: GraphControlViewModelInputs { self }
    var outputs: GraphControlViewModelOutputs { self }

    var backButtonObserver = PublishRelay<Int>()
    var forwardButtonObserver = PublishRelay<Int>()

    var backButtonDidPressed: Driver<Int> {
        backButtonObserver.asDriver(onErrorJustReturn: 0)
    }
    var forwardButtonDidPressed: Driver<Int> {
        forwardButtonObserver.asDriver(onErrorJustReturn: 0)
    }

    init() {

    }

}
