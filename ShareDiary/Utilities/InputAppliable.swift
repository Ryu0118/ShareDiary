//
//  InputAppliable.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/05.
//

import Foundation

protocol InputAppliable {
    associatedtype Input
    func apply(input: Input)
}

extension InputAppliable {

    func apply(inputs: [Input]) {
        for input in inputs {
            self.apply(input: input)
        }
    }

}
