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
    
    let container = Container(token: GithubUserDefaults.getToken())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: - 토큰 유효기간 판단
        // 토큰저장할때: 토큰 & 토큰이 저장된 시간 & 유효시간(1일)
        // 토큰이 유효한지 판단
        // UserDefaults.토큰이저장된시간 > 1일
        // { 다시 로그인을 해야된다고 판단 => UerDefaults.token 삭제 }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = container.buildRootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        OAuthService().fetchToken(from: url) { [weak self] accessToken in
            guard let token = accessToken else {
                // TODO: 로그인 실패 얼럿띄우기
                return
            }
            GithubUserDefaults.setToken(token)
            self?.container.setToken(token)
            self?.window?.rootViewController = self?.container.buildRootViewController()
        }
        return true
    }
}
