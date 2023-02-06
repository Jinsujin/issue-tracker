//
//  OptionSelectModel.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/30.
//

import Foundation

class OptionSelectModel {
    
    private let environment: OptionSelectModelEnvironment
    private var options: [Optionable] {
        didSet {
            updatedOptions?()
        }
    }
    
    var updatedOptions: (() -> Void)?
    
    init(environment: OptionSelectModelEnvironment) {
        self.environment = environment
        self.options = []
    }
    
    func getOptionsCount() -> Int {
        return options.count
    }
    
    func getOption(index: Int) -> Optionable {
        return options[index]
    }
        
    func requestOptions(_ option: Option, repo: Repository) {
        switch option {
        case .label:
            environment.requestRepositoryLabels(repo) { [weak self] result in
                switch result {
                case .success(let repositoryList):
                    self?.options = repositoryList
                case .failure(let error):
                    print(error)
                }
            }
        case .milestone:
            environment.requestRepositoryMilestones(repo) { [weak self] result in
                switch result {
                case .success(let repositoryList):
                    self?.options = repositoryList
                case .failure(let error):
                    print(error)
                }
            }
        case .assignee:
            environment.requestRepositoryAssigness(repo) { [weak self] result in
                switch result {
                case .success(let repositoryList):
                    self?.options = repositoryList
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

struct OptionSelectModelEnvironment {
    let requestRepositoryLabels: (Repository, @escaping (Result<[Label], OptionError>) -> Void) -> Void
    let requestRepositoryMilestones: (Repository, @escaping (Result<[Milestone], OptionError>) -> Void) -> Void
    let requestRepositoryAssigness: (Repository, @escaping (Result<[Assignee], OptionError>) -> Void) -> Void
}
