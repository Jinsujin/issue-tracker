import Foundation

enum QueryParameter: CustomStringConvertible {
    case scope
    case clientId
    case clientSecret
    case code
    
    var description: String {
        switch self {
        case .scope:
            return "scope"
        case .clientId:
            return "client_id"
        case .clientSecret:
            return "client_secret"
        case .code:
            return "code"
        }
    }
}
