//
//  PrivateStorage.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/15.
//

import Foundation

struct PrivateStorage {
    
    private let configPath = Bundle.main.path(forResource: "Config", ofType: "plist")
    
    private let clientIdKey = "OAUTH_CLIENT_ID"
    private let clientSecretKey = "OAUTH_CLIENT_SECRET"
    
    enum PrivateStorageError: Error {
        case clientIdNotFound
        case clientSecretNotFound
    }
    
    func getClientId() throws -> String {
        guard let configDic = configPath,
           let plist = NSDictionary(contentsOfFile: configDic),
           let oauthClientId = plist.object(forKey: clientIdKey) as? String else {
            throw PrivateStorageError.clientIdNotFound
        }
        return oauthClientId
    }
    
    func getClientSecret() throws -> String {
        guard let configDic = configPath,
           let plist = NSDictionary(contentsOfFile: configDic),
           let oauthClientId = plist.object(forKey: clientSecretKey) as? String else {
            throw PrivateStorageError.clientSecretNotFound
        }
        return oauthClientId
    }
}
