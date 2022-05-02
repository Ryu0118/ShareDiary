//
//  String+extensions.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation
import RxSwift

extension String: LocalizedError {

    func asObservable() -> Observable<String> {
        Observable<String>.just(self)
    }

}
