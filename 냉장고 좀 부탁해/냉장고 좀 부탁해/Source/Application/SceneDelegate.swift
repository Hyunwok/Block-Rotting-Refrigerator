//
//  SceneDelegate.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/09.
//

import UIKit

import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        printRealmURL()
        settingTabbar()
        requestAuthNoti()
        setting()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            let nav: UINavigationController = AppDIContainer.shared.resolve(registrationName: "Base")
            self.window?.rootViewController = nav
            
            let coordinator: Coordinator = AppDIContainer.shared.resolve()
            coordinator.start()
            
            self.window?.makeKeyAndVisible()
        }
    }
    
    func setting() {
        UserDefaultStorage.shared.lastStartDate = Date()
        if !UserDefaultStorage.shared.isFirstLaunch {
            UserDefaultStorage.shared.remainDay = 1
            
            UserDefaultStorage.shared.isFirstLaunch = true
        }
    }
    
    func requestAuthNoti() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().requestAuthorization(options: notiAuthOptions) { (success, error) in
            if let error = error {
                print(#function, error)
            }
        }
    }
    
    func versionMigration() { // realm 마이그레이션
        //        let config = Realm.Configuration(schemaVersion: 1,
        //                                         migrationBlock: { migration, oldVersion in
        //                                            migration.enumerateObjects(ofType: Review.className()) { oldObj, newObj in
        //                                                newObj!["rates"] = 0.0
        //                                            }
        //                                         })
        //
        //        Realm.Configuration.defaultConfiguration = config
    }
    
    func printRealmURL() {
        print("path = \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    func settingTabbar() {
        UITabBar.appearance().tintColor = .customGreen
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
