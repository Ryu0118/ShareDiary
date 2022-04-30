//
//  Regex.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation

class Regex {
    static func evaluate(_ text: String, pattern: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        let result = regex.evaluate(with: text)
        return result
    }
}

extension Regex {
    static func isValidEmail(_ text: String) -> Bool {
        evaluate(text, pattern: "^[a-zA-Z0-9_+-]+(.[a-zA-Z0-9_+-]+)*@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*.)+[a-zA-Z]{2,}$")
    }

    static func isValidPassword(_ text: String) -> Bool {
        evaluate(text, pattern: "^[a-zA-Z0-9]{8,24}$")
    }
}
