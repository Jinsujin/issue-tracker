//
//  Milestone.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/16.
//

import Foundation

// MARK: - Milestone
struct Milestone: Codable, Optionable {
    var subTitle: String {
        self.title
    }
    
    let number: Int
    let title: String
    let description: String
    let openIssues, closedIssues: Int
    let state: String
    let dueOn: String?
}
