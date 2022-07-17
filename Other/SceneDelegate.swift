//
//  SceneDelegate.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/29.
//

import UIKit
import FirebaseAuth
import Firebase
import ProgressHUD
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var firebaseToken: String?

    var currentViewController: UIViewController?

    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window

        // login check
        if let currentUser = Auth.auth().currentUser {
            let main = MainViewController()
            currentViewController = main
            window.rootViewController = main
            window.makeKeyAndVisible()
            currentUser.getIDToken {[weak self] idToken, _ in
                self?.firebaseToken = idToken
            }
        } else {
            let login = LoginViewController()
            currentViewController = login
            window.rootViewController = login
            window.makeKeyAndVisible()
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else { return }
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] link, _ in
            guard let linkURL = link?.url else { return }
            self?.handlePasswordlessSignIn(withURL: linkURL)
        }
    }

    func handlePasswordlessSignIn(withURL url: URL) {
        let link = url.absoluteString
        let (email, password) = (Persisted.auth.email, Persisted.auth.password)
        Authorization.shared.isAlreadyUsedEmail(email: email)
            .withUnretained(self)
            .subscribe(onNext: { strongSelf, isAlreadyUsed in
                guard !isAlreadyUsed else {
                    ProgressHUD.showFailed(NSLocalizedString("無効なリンク", comment: ""))
                    return
                }
                if Auth.auth().isSignIn(withEmailLink: link) && !email.isEmpty && !password.isEmpty {
                    let setProfileVC =
                        SetProfileViewController(authType: .email, viewModel: SetProfileViewModel(authType: .email))
                    setProfileVC.modalPresentationStyle = .fullScreen
                    setProfileVC.modalTransitionStyle = .coverVertical
                    strongSelf.window?.rootViewController = setProfileVC
                    strongSelf.window?.makeKeyAndVisible()
                } else {

                }
            })
            .disposed(by: disposeBag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
