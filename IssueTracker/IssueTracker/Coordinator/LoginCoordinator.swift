import Foundation
import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    let container: Container
    var childCoordinators: [Coordinator] = []
    
    var delegate: LoginCoordinatorDelegate?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let environment = LoginModelEnvironment { [weak self] completion in
            self?.container.environment.oAuthService.requestCode(completion: { result in
                completion(result)
            })
        }
        let model = LoginModel(environment: environment)
        let viewController = LoginViewController(model: model)
        
        container.register(model)
        container.register(viewController)
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func login() {
        self.delegate?.didLoggedIn(coordinator: self)
    }
}
