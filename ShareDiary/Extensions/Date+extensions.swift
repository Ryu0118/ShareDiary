//
//  Date+extensions.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/11.
//

import Foundation

extension Date {

    func difference(_ date: Date) -> Int {
        abs(Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0)
    }

    func getYear() -> Int {
        Calendar.current.component(.year, from: self)
    }

    func getMonth() -> Int {
        Calendar.current.component(.month, from: self)
    }

    func getDate() -> Int {
        Calendar.current.component(.day, from: self)
    }

}
