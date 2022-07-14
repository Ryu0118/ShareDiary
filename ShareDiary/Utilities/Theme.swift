//
//  ThemeManager.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import UIKit
import Rswift

class UserSettings {
    static let shared = UserSettings()
    private init() {}

    @PersistedColor("dynamicTextColor", dafaultColor: .dynamicColor(light: .black, dark: .white))
    var dynamicTextColor: UIColor

    @PersistedColor("dynamicTextColorInvert", dafaultColor: .dynamicColor(light: .white, dark: .black))
    var dynamicTextColorInvert: UIColor

    @PersistedColor("dynamicBackgroundColor", dafaultColor: .dynamicColor(light: .rgba(red: 248, green: 247, blue: 252, alpha: 1), dark: .black))
    var dynamicBackgroundColor: UIColor

    @PersistedColor("dynamicTextGray", dafaultColor: .dynamicColor(light: .rgba(red: 142, green: 142, blue: 159, alpha: 1), dark: .lightGray))
    var dynamicTextGray: UIColor

    @PersistedColor("dynamicThemeColor", dafaultColor: .dynamicColor(light: UIColor(hex: "CCDECE"), dark: .rgba(red: 74, green: 164, blue: 156, alpha: 1)))
    var dynamicThemeColor: UIColor

    @PersistedColor("dynamicCellColor", dafaultColor: .dynamicColor(light: .rgba(red: 248, green: 247, blue: 252, alpha: 1), dark: .rgba(red: 18, green: 18, blue: 18, alpha: 1)))
    var dynamicCellColor: UIColor

    @PersistedColor("themeColor", dafaultColor: .rgba(red: 141, green: 164, blue: 165, alpha: 1))
    var themeColor: UIColor

    @PersistedColor("backgroundColor", dafaultColor: .rgba(red: 248, green: 247, blue: 252, alpha: 1))
    var backgroundColor: UIColor

    @PersistedColor("textGray", dafaultColor: .rgba(red: 142, green: 142, blue: 159, alpha: 1))
    var textGray: UIColor

    @PersistedColor("themeLightColor", dafaultColor: UIColor(hex: "CCDECE"))
    var themeLightColor: UIColor

    @PersistedColor("progressBackgroundColor", dafaultColor: .rgba(red: 241, green: 250, blue: 254, alpha: 1))
    var progressBackgroundColor: UIColor
}

struct Theme {

    // static let shared = ThemeManager()

    struct Color {
        struct Dynamic {
            static var appTextColor: UIColor = .dynamicColor(light: .black, dark: .white)
            static var appTextColorInvert: UIColor = .dynamicColor(light: .white, dark: .black)
            static var appBackgroundColor: UIColor = .dynamicColor(light: .rgba(red: 248, green: 247, blue: 252, alpha: 1), dark: .black)
            static var textGray: UIColor = .dynamicColor(light: .rgba(red: 142, green: 142, blue: 159, alpha: 1), dark: .lightGray)
            static var appThemeColor: UIColor = .dynamicColor(light: UIColor(hex: "CCDECE"), dark: .rgba(red: 74, green: 164, blue: 156, alpha: 1))
            static var appCellColor: UIColor = .dynamicColor(light: .rgba(red: 248, green: 247, blue: 252, alpha: 1), dark: .rgba(red: 18, green: 18, blue: 18, alpha: 1))
        }

        static var appThemeColor: UIColor = .rgba(red: 141, green: 164, blue: 165, alpha: 1)
        static var appThemeDeepColor: UIColor = .rgba(red: 74, green: 164, blue: 156, alpha: 1)
        static var appBackgroundColor: UIColor = .rgba(red: 248, green: 247, blue: 252, alpha: 1)
        static var textGray: UIColor = .rgba(red: 142, green: 142, blue: 159, alpha: 1)
        static var appThemeLightColor = UIColor(hex: "CCDECE")
        static var progressBackgroundColor = UIColor.rgba(red: 241, green: 250, blue: 254, alpha: 1)

    }

    enum FontSize: CGFloat {
        case heavy = 30
        case bold = 22
        case medium = 16
        case light = 13
    }

    struct Font {
        //        static var appHeavyFont = UIFont(name: "Avenir-Heavy", size: FontSize.heavy.rawValue) ?? .boldSystemFont(ofSize: FontSize.heavy.rawValue)
        //        static var appMediumFont = UIFont(name: "Avenir-Medium", size: FontSize.heavy.rawValue) ?? .systemFont(ofSize: FontSize.medium.rawValue)
        //        static var appLightFont = UIFont(name: "Avenir-Light", size: FontSize.light.rawValue) ?? .systemFont(ofSize: FontSize.light.rawValue)
        //
        //        static func getAppFont(size: CGFloat) -> UIFont {
        //            if size >= FontSize.heavy.rawValue {
        //                return UIFont(name: "Avenir-Heavy", size: size) ?? .boldSystemFont(ofSize: size)
        //            } else if size < FontSize.heavy.rawValue && size >= FontSize.medium.rawValue {
        //                return UIFont(name: "Avenir-Medium", size: size) ?? .systemFont(ofSize: size)
        //            } else {
        //                return UIFont(name: "Avenir-Light", size: size) ?? .systemFont(ofSize: size)
        //            }
        //        }

        static var appHeavyFont: UIFont = .boldSystemFont(ofSize: FontSize.heavy.rawValue)
        static var appMediumFont: UIFont = .systemFont(ofSize: FontSize.medium.rawValue)
        static var appLightFont: UIFont = .systemFont(ofSize: FontSize.light.rawValue)

        static func getAppFont(size: CGFloat) -> UIFont {
            if size >= FontSize.heavy.rawValue {
                return .systemFont(ofSize: size, weight: .heavy)
            } else if size < FontSize.heavy.rawValue && size >= FontSize.bold.rawValue {
                return .boldSystemFont(ofSize: size)
            } else if size < FontSize.bold.rawValue && size >= FontSize.medium.rawValue {
                return .systemFont(ofSize: size)
            } else {
                return .systemFont(ofSize: size)
            }
        }

        static func getAppBoldFont(size: CGFloat) -> UIFont {
            .boldSystemFont(ofSize: size)
        }

        func changeTheme(with color: UIColor) {

        }

    }
}
