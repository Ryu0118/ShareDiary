//
//  CellIdentifiable.swift
//  ShareDiary
//
//  Created by Ryu on 2022/07/17.
//

import Foundation

protocol CellIdentifiable {
    static var identifier: String { get }
}

extension CellIdentifiable {
    static var identifier: String {
        return String(describing: self.self)
    }
}
