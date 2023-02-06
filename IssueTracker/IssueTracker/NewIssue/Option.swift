//
//  Option.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/30.
//

import Foundation

enum Option: CaseIterable {
    case label
    case milestone
    case assignee
    
    var description: String {
        switch self {
        case .label:
            return "레이블"
        case .milestone:
            return "마일스톤"
        case .assignee:
            return "담당자"
        }
    }
}
