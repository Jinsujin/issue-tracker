//
//  LoginModel.swift
//  IssueTracker
//
//  Created by Bibi on 2022/07/22.
//

import Foundation

class LoginModel {
    
    private let environment: LoginModelEnvironment
    
    init(environment: LoginModelEnvironment) {
        self.environment = environment
    }
    
    func requestCode(completion: @escaping (Result<URL, OAuthError>) -> Void) {
        environment.requestCode { result in
            completion(result)
        }
    }
}

struct LoginModelEnvironment {
    let requestCode: (@escaping (Result<URL, OAuthError>) -> Void) -> Void
}
