//
//  AppDelegate.swift
//  IssueTracker
//
//  Created by Sujin Jin on 2022/06/13.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navController = UINavigationController()
        
        coordinator = AppCoordinator(navigationController: navController)
        
        coordinator?.start()
         
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        coordinator?.fetchToken(url: url, completion: { [weak self] bool in
            if bool {
                self?.coordinator?.showRootViewController()
            }
        })
        
        return true
    }
}
