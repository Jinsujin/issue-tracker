//
//  Assignee.swift
//  IssueTracker
//
//  Created by Bibi on 2022/07/01.
//

import Foundation

struct Assignee: Codable, Optionable {
    var subTitle: String {
        self.login
    }
    
    let login: String
}
