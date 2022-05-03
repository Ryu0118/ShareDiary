//
//  Persistedswift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation

class Persisted {
    static let shared = Persisted()
    private init() {}

    @Save<AuthorizationInfo>("Authorization", register: AuthorizationInfo(email: "", password: ""))
    static var auth: AuthorizationInfo

    @Save<String>("AppleIDEmail", register: "")
    static var appleID: String

    static func removeAuthInfo() {
        auth = AuthorizationInfo(email: "", password: "")
    }

}
