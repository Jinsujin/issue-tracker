//
//  CoordinatorViewController.swift
//  IssueTracker
//
//  Created by Bibi on 2022/09/20.
//

import Foundation

enum ViewControllerCoordinator: String, CaseIterable {
    case LoginViewController = "LoginCoordinator"
    case ReposViewController = "ReposCoordinator"
    case IssueViewController = "IssueCoordinator"
    case NewIssueViewController = "NewIssueCoordinator"
    case OptionSelectViewController = "OptionSelectCoordinator"
}
