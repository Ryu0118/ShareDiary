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

    var authenticationResponse: Single<String>!

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

extension LoginWithAppleHelper: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding & ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 認証完了時
        handle(authorization.credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 認証失敗時
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // ASAuthorizationControllerPresentationContextProvidingのメソッド
        return currentController?.view.window ?? UIWindow()
    }

    func handle(_ credential: ASAuthorizationCredential) {
        // 認証完了後ASAuthorizationCredentialから必要な情報を取り出す
        // エラー時のハンドリングはアプリごとに違うので省略
        self.authenticationResponse = Single<String>.create { singleEvent -> Disposable in
            guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
                // キャスト失敗。ASPasswordCredential（パスワードは今回要求していないので起きないはず）だと失敗する
                singleEvent(.failure("failed to cast"))
                return Disposables.create()
            }
            guard let nonce = self.currentNonce else {
                // ログインリクエスト失敗
                singleEvent(.failure("failed to request login"))
                return Disposables.create()
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                // ユーザーに関する情報をアプリに伝えるためのJSON Web Tokenの取得に失敗
                singleEvent(.failure("Unable to fetch identity token"))
                return Disposables.create()
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                // JWTからトークン(文字列)へのシリアライズに失敗
                singleEvent(.failure("Serialization from JWT to token (string) fails"))
                return Disposables.create()
            }

            // Sign In With Appleの認証情報を元にFirebase Authenticationの認証
            let oAuthCredential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce)

            Auth.auth().signIn(with: oAuthCredential) { _, error in
                if let error = error {
                    singleEvent(.failure(error))
                } else {
                    singleEvent(.success(""))
                    self.currentController?.navigationController?.popViewController(animated: true)
                }
            }
            return Disposables.create()
        }

    }

}

// extension ASAuthorization.Scope {
//    public static let fullName: ASAuthorization.Scope
//    public static let email: ASAuthorization.Scope
// }
