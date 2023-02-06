import Foundation

enum RequestURL: CustomStringConvertible {
    case authorize
    case accessToken
    case issues
    case userIssues
    case createIssue(owner: String, repo: String)
    case repos
    case repositoryIssue(owner: String, repo: String)
    case repositoryLabels(owner: String, repo: String)
    case repositoryMilestones(owner: String, repo: String)
    case repositoryAssignees(owner: String, repo: String)
    
    var description: String {
        switch self {
        case .authorize:
            return "https://github.com/login/oauth/authorize"
        case .accessToken:
            return "https://github.com/login/oauth/access_token"
        case .issues:
            return "https://api.github.com/issues"
        case .userIssues:
            return "https://api.github.com/user/issues"
        case let .createIssue(owner, repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/issues"
        case .repos:
            return "https://api.github.com/user/repos"
        case let .repositoryIssue(owner, repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/issues"
        case let .repositoryLabels(owner, repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/labels"
        case let .repositoryMilestones(owner, repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/milestones"
        case let .repositoryAssignees(owner, repo):
            return  "https://api.github.com/repos/\(owner)/\(repo)/assignees"
        }
    }
}
