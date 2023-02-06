//
//  NewIssueModel.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/30.
//

import Foundation

class NewIssueModel {
    
    private let environment: NewIssueModelEnvironment
    
    init(environment: NewIssueModelEnvironment) {
        self.environment = environment
    }
    
    func createIssue(newIssue: NewIssueFormat, completion: @escaping (Bool) -> Void) {
        environment.createIssue(newIssue) { boolResult in
            completion(boolResult)
        }
    }
    
    func requestIssue(completion: @escaping ([String]?) -> Void) {
        environment.requestRepositoryIssues() { result in
            switch result {
            case .success(let issues):
                let issuesTitleArr = issues.map{ $0.title }
                completion(issuesTitleArr)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

struct NewIssueModelEnvironment {
    let createIssue: (NewIssueFormat, @escaping (Bool) -> Void) -> Void
    
    let requestRepositoryIssues: (@escaping (Result<[Issue], IssueError>) -> Void) -> Void
}
