//
//  Array+safe.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
