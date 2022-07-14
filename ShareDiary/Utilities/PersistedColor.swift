//
//  PersistedColor.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/30.
//

import UIKit

@propertyWrapper
struct PersistedColor {

    let forKey: String
    let userDefaults = UserDefaults.standard

    init(_ forKey: String, dafaultColor: UIColor) {
        self.forKey = forKey
        if let data = colorToData(color: dafaultColor) {
            userDefaults.register(defaults: [forKey: data])
        } else {
            fatalError("cannot convert color to data")
        }
    }

    var wrappedValue: UIColor {
        get {
            var colorReturnded: UIColor?
            if let colorData = userDefaults.data(forKey: forKey) {
                do {
                    if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                        colorReturnded = color
                    }
                } catch {
                    print(error)
                }
            }
            return colorReturnded ?? UIColor(hex: "FFFFFF")
        }
        set {
            let data = colorToData(color: newValue)
            userDefaults.set(data, forKey: forKey)
        }
    }

    private func colorToData(color: UIColor) -> Data? {
        var colorData: Data?
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            colorData = data
        } catch {
            print(error)
            return nil
        }
        return colorData
    }
}
