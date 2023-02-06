import UIKit

class Container {
    
    let environment: ContainerEnvironment
    private var registeredObjects: [String: Any] = [:]
    private var registeredViewControllerCoordinator: [UIViewController : Coordinator] = [:]
    
    init(environment: ContainerEnvironment) {
        self.environment = environment
    }
    
    // model, viewcontroller, coordinator를 생성 시점에 등록함
    func register<T>(_ object: T) {
        let key = String(describing: T.self)
        registeredObjects[key] = object
        if let viewControllerObject = object as? UIViewController {
            registerPairCoordinator(with: viewControllerObject)
        }
    }
    
    // let value: Type = container.resolve() 로 사용
    func resolve<T>() -> T? {
        let key = String(describing: T.self)
        guard let object = registeredObjects[key],
              let object = object as? T else {
            print("⚠️\(key)는 register되지 않음")
            return nil
        }
        return object
    }
    
    func registerPairCoordinator(with viewController: UIViewController) {
        let viewControllerName = String(describing: type(of: viewController))
        
        let allViewController = ViewControllerCoordinator.allCases
        for oneCase in allViewController {
            let oneCaseName = String(describing: oneCase) // Enum case의 이름을 String으로 변환
            if oneCaseName == viewControllerName {
                let coordinatorName = oneCase.rawValue
                guard let coordinator = registeredObjects[coordinatorName],
                      let castedCoordinator = coordinator as? Coordinator else {
                    return
                }
                registeredViewControllerCoordinator[viewController] = castedCoordinator
            }
        }
    }
    
    func resolvePair(of viewController: UIViewController) -> Coordinator? {
        return registeredViewControllerCoordinator[viewController]
    }
    
    func fetchAccessToken(url: URL, completion: @escaping (Bool) -> Void) {
        environment.oAuthService.fetchToken(from: url) { [weak self] accessToken in
            guard let token = accessToken,
                  let self = self else {
                completion(false)
                return
            }
            self.environment.githubUserDefaults.setToken(token)
            self.environment.issueService.setAccessToken(token)
            completion(true)
        }
    }
}

// Container에 필요한 Environment : 필요한 의존성을 가진 객체
struct ContainerEnvironment {
    var githubUserDefaults: GithubUserDefaults
    var oAuthService: OAuthService
    var issueService: IssueService
    
    static let live: ContainerEnvironment = {
        let githubUserDefaults = GithubUserDefaults()
        let token = githubUserDefaults.getToken()
        
        // MARK: 문제 발생 지점 - 로그인 전에는 토큰이 없으므로 ""가 들어감
        return ContainerEnvironment(githubUserDefaults: githubUserDefaults, oAuthService: OAuthService(), issueService: IssueService())
    }()
}
