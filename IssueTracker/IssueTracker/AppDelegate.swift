//
//  AppDelegate.swift
//  IssueTracker
//
//  Created by Sujin Jin on 2022/06/13.
//

import UIKit
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if url.absoluteString.starts(with: "issuetracker://login") {
            if let code = url.absoluteString.split(separator: "=").last.map { String($0) } {
                print(code)
                requestAccessToken(with: code)
            }
        }
        return true
    }
    
    private func requestAccessToken(with code: String) {
        let url = "https://github.com/login/oauth/access_token"
        
        let parameters = ["client_id": "\(PrivateStorage.clientId)",
                          "client_secret": "\(PrivateStorage.clientSecret)",
                          "code": code]
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: [String: String].self) { (response) in
            switch response.result {
            case let .success(json):
                if let dic = json as? [String: String] {
                    print(dic["access_token"])
                    print(dic["scope"])
                    print(dic["token_type"])
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

