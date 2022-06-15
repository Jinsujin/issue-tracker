//
//  PrivateStorage.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/15.
//

import Foundation

struct PrivateStorage {
    
    static private let configPath = Bundle.main.path(forResource: "Config", ofType: "plist")
    
    static var clientId: String {
        get {
            guard let configDic = configPath,
               let plist = NSDictionary(contentsOfFile: configDic),
               let oauthClientId = plist.object(forKey: "OAUTH_CLIENT_ID") as? String else {
                fatalError("Could not find 'client_id' from 'Config.plist'.")
            }
            return oauthClientId
        }
    }
    
    static var clientSecret: String {
        get {
            guard let configDic = configPath,
               let plist = NSDictionary(contentsOfFile: configDic),
               let oauthClientId = plist.object(forKey: "OAUTH_CLIENT_SECRET") as? String else {
                fatalError("Could not find 'client_secret' from 'Config.plist'.")
            }
            return oauthClientId
        }
    }
}
