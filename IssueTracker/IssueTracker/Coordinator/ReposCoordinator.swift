//
//  ReposCoordinator.swift
//  IssueTracker
//
//  Created by Bibi on 2022/08/09.
//

import Foundation
import UIKit

protocol ReposCoordinatorDelegate {
    func didSelect(repository: Repository)
}

class ReposCoordinator: Coordinator {
    var container: Container
    
    var childCoordinators: [Coordinator] = []
    
    let navigationController: UINavigationController
    
    var delegate: ReposCoordinatorDelegate?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let environment = ReposModelEnvironment(requestRepos: { [weak self] completion in
            self?.container.environment.issueService.requestRepos(completion: { result in
                completion(result)
            })
        })
        let model = ReposModel(environment: environment)
        let viewController = ReposViewController(model: model)
        
        container.register(model)
        container.register(viewController)
        
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension ReposCoordinator: ReposViewControllerDelegate {
    func showIssue(didSelectRowAt indexPath: IndexPath) {
        guard let model: ReposModel = container.resolve() else {
            return
        }
        let selectedRepo = model.getViewData(index: indexPath.row)
        self.delegate?.didSelect(repository: selectedRepo)
    }
}

