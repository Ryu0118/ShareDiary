//
//  RegistrationViewController+OAuth.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation
import CryptoKit
import AuthenticationServices
import RxSwift
import RxCocoa
import FirebaseAuth

// Cannot write to ViewModel Because UIViewController can only be Authentication Delegate
extension RegistrationViewController {
    func requestSignInAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}

// Cannot write to ViewModel Because UIViewController can only be Authentication Delegate
extension RegistrationViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handle(authorization.credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authenticationResponse.accept(NSLocalizedString("認証がキャンセルされました。再度ログインしてください。", comment: ""))
    }

    func handle(_ credential: ASAuthorizationCredential) {
        guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
            authenticationResponse.accept(NSLocalizedString("エラーが発生しました。再度ログインしてください。", comment: ""))
            return
        }
        guard let nonce = self.currentNonce else {
            authenticationResponse.accept("リクエストの送信に失敗しました。再度ログインしてください。")
            return
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            authenticationResponse.accept("Json Web Tokenの取得に失敗しました")
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            authenticationResponse.accept("シリアライズに失敗しました。")
            return
        }

        let oAuthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce)

        Auth.auth().signIn(with: oAuthCredential) {[weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.authenticationResponse.accept(error.localizedDescription)
            } else {
                self.authenticationResponse.accept("")
                self.navigationController?.popViewController(animated: true)
            }

        }

    }
}
