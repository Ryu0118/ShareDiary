//
//  AuthType.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/03.
//

import Foundation
import FirebaseAuth
import AuthenticationServices

enum AuthType {
    case email
    case apple(OAuthCredential)
    case google(AuthCredential)
    case twitter
}
