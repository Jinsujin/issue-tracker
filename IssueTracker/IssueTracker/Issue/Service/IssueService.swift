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

struct IssueService {
    
    func requestIssues(accessToken: String, completion: @escaping (Result<[Issue], IssueError>) -> Void) {
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
    
    func createIssue(title: String, repo: Repository, accessToken: String, completion: @escaping (Bool) -> Void) {
        let urlString = RequestURL.createIssue(owner: repo.owner.login, repo: repo.name).description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        let parameters: [String: Any] = [
            "title": title
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
                case let .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }
    
    func requestRepos(accessToken: String, completion: @escaping (Result<[Repository], IssueError>) -> Void) {
        let urlString = RequestURL.repos.description
        let headers: HTTPHeaders = [
            NetworkHeader.acceptV3.getHttpHeader(),
            NetworkHeader.authorization(accessToken: accessToken).getHttpHeader()
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let globalThread = DispatchQueue.global(qos: .default)
        
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
}
