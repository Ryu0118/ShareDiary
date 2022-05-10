//
//  LoginWithAppleHelper.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/01.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import AuthenticationServices
import CryptoKit

class LoginWithAppleHelper: NSObject {

    var currentNonce: String?
    private var currentController: UIViewController?

    var authenticationResponse = PublishRelay<String>()

    init(_ currentController: UIViewController) {
        self.currentController = currentController
    }

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

extension LoginWithAppleHelper: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        currentController?.view.window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handle(authorization.credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authenticationResponse.accept("認証に失敗しました。再度ログインしてください。")
    }

    func handle(_ credential: ASAuthorizationCredential) {
        // 認証完了後ASAuthorizationCredentialから必要な情報を取り出す
        // エラー時のハンドリングはアプリごとに違うので省略
        guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
            // キャスト失敗。ASPasswordCredential（パスワードは今回要求していないので起きないはず）だと失敗する
            authenticationResponse.accept(NSLocalizedString("エラーが発生しました。再度ログインしてください。", comment: ""))
            return
        }
        guard let nonce = self.currentNonce else {
            // ログインリクエスト失敗
            authenticationResponse.accept("リクエストの送信に失敗しました。再度ログインしてください。")
            return
        }

        guard let appleIDToken = appleIDCredential.identityToken else {
            // ユーザーに関する情報をアプリに伝えるためのJSON Web Tokenの取得に失敗
            authenticationResponse.accept("Json Web Tokenの取得に失敗しました")
            return
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            // JWTからトークン(文字列)へのシリアライズに失敗
            authenticationResponse.accept("シリアライズに失敗しました。")
            return
        }

        // Sign In With Appleの認証情報を元にFirebase Authenticationの認証
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
                self.currentController?.navigationController?.popViewController(animated: true)
            }

        }

    }

}
