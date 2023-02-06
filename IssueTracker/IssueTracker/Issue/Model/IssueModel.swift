//
//  IssueModel.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/21.
//

import Foundation

class IssueModel {

    private let environment: IssueModelEnvironment
    
    init(environment: IssueModelEnvironment) {
        self.environment = environment
    }
    
    var issuesUpdated: ( () -> Void )?
    
    private var issues: [Issue] = [] {
        didSet {
            issuesUpdated?()
        }
    }
    
    func getIssuesCount() -> Int {
        return issues.count
    }
    
    func getIssue(at index: Int) -> Issue? {
        if issues.indices.contains(index) {
            return issues[index]
        }
        return nil
    }
    
    func requestIssue(completion: @escaping ([String]?) -> Void) {
        environment.requestRepositoryIssues() { result in
            switch result {
            case .success(let issues):
                self.issues = issues
                let issuesTitleArr = issues.map{ $0.title }
                completion(issuesTitleArr)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

struct IssueModelEnvironment {
    // completion을 파라미터로 받고, 리턴타입은 Void인 클로저
    let requestRepositoryIssues: (@escaping (Result<[Issue], IssueError>) -> Void) -> Void
}
