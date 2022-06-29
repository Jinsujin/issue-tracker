//
//  Container.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/22.
//

import UIKit

import UIKit

struct Container {
    enum Screen {
        case login
        case issue(token: String)
        case newIssue
        case optionSelect(token: String, option: Option)
    }
    
    func buildRootViewController() -> UIViewController {
        if let accessToken = GithubUserDefaults.getToken() {
            return buildViewController(.issue(token: accessToken))
        } else {
            return buildViewController(.login)
        }
    }
    
    func buildViewController(_ screen: Screen) -> UIViewController {
        switch screen {
        case .login:
            return LoginViewController(service: OAuthService())
        case .issue(let token):
            let service = IssueService()
            let model = IssueModel(service: service, token: token)
            let viewController = IssueViewController(model: model)
            return UINavigationController(rootViewController: viewController)
        case .newIssue:
            return NewIssueViewController()
        case .optionSelect(let token, let option):
            return OptionSelectViewController(token: token, option: option)
        }
    }
}
