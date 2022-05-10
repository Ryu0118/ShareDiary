//
//  LoginViewModel.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/30.
//

import RxSwift
import RxCocoa
import FirebaseAuth

protocol LoginViewModelInputs: AnyObject {
    var emailObserver: AnyObserver<String> { get }
    var passwordObserver: AnyObserver<String> { get }
    func loginWithEmail(email: String, password: String) -> Observable<String>
    func loginWithGoogle() -> Observable<String>
    func loginWithTwitter(provider: OAuthProvider) -> Observable<String>
}

protocol LoginViewModelOutputs: AnyObject {
    var isValidEmail: Observable<String> { get }
    var isValidPassword: Observable<String> { get }
    var shouldLogin: Observable<[String]> { get }
}

class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs {

    var inputs: LoginViewModelInputs { self }
    var outputs: LoginViewModelOutputs { self }

    // inputs
    private let emailSubject = BehaviorSubject<String>(value: "")
    var emailObserver: AnyObserver<String> {
        emailSubject.asObserver()
    }

    private let passwordSubject = BehaviorSubject<String>(value: "")
    var passwordObserver: AnyObserver<String> {
        passwordSubject.asObserver()
    }

    // outputs
    var isValidEmail: Observable<String>
    var isValidPassword: Observable<String>
    var shouldLogin: Observable<[String]>

    init() {
        isValidEmail = emailSubject
            .map { Regex.isValidEmail($0) ? "" : "正しいメールアドレスを入力してください" }

        isValidPassword = passwordSubject
            .map { Regex.isValidPassword($0) ? "" : "8文字以上24文字以内の英数字で入力してください" }

        shouldLogin = Observable.combineLatest(isValidEmail, isValidPassword) {email, password -> [String] in
            var response = [String]()
            if !email.isEmpty {
                response.append(email)
            }
            if !password.isEmpty {
                response.append(password)
            }
            return response
        }

    }

    func loginWithEmail(email: String, password: String) -> Observable<String> {
        SignInWithMailHelper().signInWithMail(email: email, password: password)
    }

    func loginWithGoogle() -> Observable<String> {
        SignInWithGoogleHelper().signInWithGoogle()
    }

    func loginWithTwitter(provider: OAuthProvider) -> Observable<String> {
        SignInWithTwitterHelper().signInWithTwitter(provider: provider)
    }

}
