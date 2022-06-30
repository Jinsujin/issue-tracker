//
//  IssueService.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/21.
//

import Foundation
import Alamofire


enum IssueError: Error {
    case issueNotFound
    case cannotCreateIssue
}

enum OptionError: Error {
    case labelNotFound
    case milestonesNotFound
}

struct IssueService {
    
    private let accessToken: String
    
    init(token: String) {
        self.accessToken = token
    }
    
    func requestIssues(completion: @escaping (Result<[Issue], IssueError>) -> Void) {
        let urlString = RequestURL.issues.description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let globalThread = DispatchQueue.global(qos: .default)
        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .responseDecodable(of: [Issue].self,
                               queue: globalThread,
                               decoder: decoder) { (response) in
            switch response.result {
            case let .success(decodeData):
                completion(.success(decodeData))
            case .failure:
                completion(.failure(.issueNotFound))
            }
        }
    }
    
    func createIssue(title: String, label: Label?, repo: Repository, completion: @escaping (Bool) -> Void) {
        let urlString = RequestURL.createIssue(owner: repo.owner.login, repo: repo.name).description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        var labelList: [String] = []
        if let label = label {
            labelList.append(label.name)
        }
        
        let parameters: [String: Any] = [
            "title": title,
            "labels": labelList
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(urlString,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
    }
    
    func requestRepositoryIssues(repo: Repository, completion: @escaping (Result<[Issue], IssueError>) -> Void) {
        let urlString = RequestURL.createIssue(owner: repo.owner.login, repo: repo.name).description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(urlString, method: .get, headers: headers)
            .responseDecodable(of: [RepositoryIssue].self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    var result: [Issue] = []
                    for entity in data {
                        // pullRequest 가 없으면(nil) 일반이슈, 있으면 PR 이슈
                        if entity.pullRequest != nil {
                            continue
                        }
                        let issue = Issue(title: entity.title, body: entity.body, state: entity.state, labels: entity.labels, milestone: entity.milestone, repository: repo)
                        result.append(issue)
                    }
                    completion(.success(result))
                case .failure(let error):
                    print(error)
                    completion(.failure(.issueNotFound))
                }
            }
    }
    
    func requestRepos(completion: @escaping (Result<[Repository], IssueError>) -> Void) {
        let urlString = RequestURL.repos.description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(urlString, method: .get, headers: headers)
            .responseDecodable(of: [Repository].self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(.issueNotFound))
                }
            }
    }
    
    func requestRepositoryLabels(repo: Repository, completion: @escaping (Result<[Label], OptionError>) -> Void) {
        let urlString = RequestURL.repositoryLabels(owner: repo.owner.login, repo: repo.name).description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(urlString, method: .get, headers: headers)
            .responseDecodable(of: [Label].self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(.labelNotFound))
                }
            }
    }
    
    
    func requestRepositoryMilestones(repo: Repository, completion: @escaping (Result<[Milestone], OptionError>) -> Void) {
        let urlString = RequestURL.repositoryMilestones(owner: repo.owner.login, repo: repo.name).description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(urlString, method: .get, headers: headers)
            .responseDecodable(of: [Milestone].self, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(.milestonesNotFound))
                }
            }
    }
}

fileprivate struct RepositoryIssue: Codable {
    let title: String
    let body: String?
    let state: String
    let labels: [Label]
    let milestone: Milestone?
    let pullRequest: PullRequest?
    
    struct PullRequest: Codable {
        let url: String
        let htmlUrl: String
        let diffUrl: String
        let patchUrl: String
        let mergedAt: String?
    }
}
