import Foundation
import Alamofire

enum NetworkHeader {
    case accept
    case acceptV3
    case authorization(accessToken: String)

    func getHttpHeader() -> HTTPHeader {
        switch self {
        case .accept:
            return HTTPHeader(name: "Accept", value: "application/json")
        case .acceptV3:
            return HTTPHeader(name: "Accept", value: "application/vnd.github.v3+json")
        case .authorization(let accessToken):
            return HTTPHeader(name: "Authorization", value: "token \(accessToken)")
        }
    }
}
