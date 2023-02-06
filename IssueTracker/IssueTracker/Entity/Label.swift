//
//  Label.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/16.
//

import Foundation

// MARK: - Label
struct Label: Codable, Optionable {
    var subTitle: String {
        self.name
    }
    
    let id: Int
    let url: String
    let name, color: String
    let labelDefault: Bool
    let labelDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case url, name, color
        case labelDefault = "default"
        case labelDescription = "description"
    }
}
