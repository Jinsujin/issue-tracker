import Foundation

struct GithubUserDefaults {

    private let key = "github_access_token"

    func setToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: key)
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
