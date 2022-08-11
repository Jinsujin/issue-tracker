//
//  Coordinator.swift
//  IssueTracker
//
//  Created by Bibi on 2022/08/09.
//

import Foundation

protocol Coordinator: AnyObject {
    var container: Container { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
}
