//
//  NewIssueFormat.swift
//  IssueTracker
//
//  Created by Bibi on 2022/08/31.
//

import Foundation

struct NewIssueFormat {
    let title: String
    let repo: Repository
    let content: String
    let label: Label?
    let milestone: Milestone?
    let assignee: Assignee?
    
}
