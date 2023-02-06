import Foundation
import Alamofire

enum OAuthError: Error {
    case tokenNotFound
    case storageKeyNotFound
}

struct OAuthService {
    func fetchToken(from url: URL, completion: @escaping (UserToken?) -> Void) {
        if !url.absoluteString.starts(with: "issuetracker://login") {
            return
        }
        guard let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) else {
            return
        }
        requestAccessToken(with: code) { result in
            switch result {
            case .success(let accessToken):
                completion(accessToken)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func requestCode(completion: @escaping (Result<URL, OAuthError>) -> Void) {
        let scope = "repo,user"
        let urlString = RequestURL.authorize.description
        guard var urlComponents = URLComponents(string: urlString) else {
           return
        }
        
        do {
            let clientId = try PrivateStorage().getClientId()
            urlComponents.queryItems = [
                URLQueryItem(name: QueryParameter.clientId.description, value: clientId),
                URLQueryItem(name: QueryParameter.scope.description, value: scope),
            ]
            
            guard let url = urlComponents.url else {
                return
            }
            completion(.success(url))
        } catch {
            completion(.failure(.storageKeyNotFound))
        }
    }
    
    private func requestAccessToken(with code: String, completion: @escaping (Result<UserToken, OAuthError>) -> Void) {
        let url = RequestURL.accessToken.description
        let privateStorage = PrivateStorage()
        guard let clientId = try? privateStorage.getClientId(),
            let clientSecret = try? privateStorage.getClientSecret() else {
            completion(.failure(.storageKeyNotFound))
            return
        }
        
        let parameters = [
            QueryParameter.clientId.description: "\(clientId)",
            QueryParameter.clientSecret.description: "\(clientSecret)",
            QueryParameter.code.description: code
        ]
        let headers: HTTPHeaders = [
            NetworkHeader.accept.getHttpHeader()
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: [String: String].self) { (response) in
            switch response.result {
            case .success(let json):
                if let accessToken = json["access_token"] {
                    completion(.success(accessToken))
                }
            case .failure:
                completion(.failure(.tokenNotFound))
            }
        }
    }
}
