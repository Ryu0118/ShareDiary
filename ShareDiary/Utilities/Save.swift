//
//  Save.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation

@propertyWrapper
struct Save<T: Codable> {
    private var saved: T
    private let forKey: String
    private let userDefaults = UserDefaults.standard

    init(_ forKey: String, register: T) {
        self.forKey = forKey
        self.saved = register
    }
    var wrappedValue: T {
        get {
            readUserDefaultsData()
        }
        set {
            setUserDefaultsData(newValue: newValue)
        }
    }
    // UserDefaultsに保存されているデータを読み込む
    private func readUserDefaultsData() -> T {
        if let data = userDefaults.data(forKey: forKey) {
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch {
                return data.withUnsafeBytes { $0.load( as: T.self ) }
            }
        } else {
            return userDefaults.object(forKey: forKey) as? T ?? saved
        }
    }
    // UserDefaultsに新しい値をセットする
    private func setUserDefaultsData(newValue: T) {
        do {
            let value = try PropertyListEncoder().encode(newValue)
            userDefaults.setValue(value, forKey: forKey)
        } catch {
            userDefaults.setValue(newValue, forKey: forKey)
        }
    }
}
