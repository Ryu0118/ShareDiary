//
//  AppDelegate.swift
//  ShareDiary
//
//  Created by Ryu on 2022/04/29.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // try? Auth.auth().signOut()
        Persisted.appleID = "shibuya0118"
        print("shibuya0118", Persisted.appleID)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension UIApplication {
    private var rootViewControllerInKeyWindow: UIViewController? {
        UIApplication.shared.connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .rootViewController
    }

    // 最前面の画面を知るために用いる。
    class func keyWindowTopViewController(on controller: UIViewController? = UIApplication.shared.rootViewControllerInKeyWindow) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return keyWindowTopViewController(on: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController,
           let selected = tabController.selectedViewController {
            return keyWindowTopViewController(on: selected)
        }
        if let presented = controller?.presentedViewController {
            return keyWindowTopViewController(on: presented)
        }
        return controller
    }

    // 最前面に画面を表示するために用いる。
    class func topViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.rootViewControllerInKeyWindow else { return nil }
        var presentedViewController = rootViewController.presentedViewController
        if presentedViewController == nil {
            return rootViewController
        } else {
            while presentedViewController?.presentedViewController != nil {
                presentedViewController = presentedViewController?.presentedViewController
            }
            return presentedViewController
        }
    }
}
