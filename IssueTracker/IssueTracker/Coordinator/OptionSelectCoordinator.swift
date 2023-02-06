//
//  OptionSelectCoordinator.swift
//  IssueTracker
//
//  Created by Bibi on 2022/08/09.
//

import Foundation
import UIKit

protocol OptionSelectCoordinatorDelegate {
    func goBackToNewIssueVC(item: Optionable, option: Option)
}

class OptionSelectCoordinator: Coordinator {
    
    var delegate: OptionSelectCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private var container: Container
    private var option: Option
    private var repo: Repository
    
    
    init(navigationController: UINavigationController, container: Container, option: Option, repo: Repository) {
        self.navigationController = navigationController
        self.container = container
        self.option = option
        self.repo = repo
    }
    
    func start() {
        let optionSelectModelEnvironment = OptionSelectModelEnvironment {
            [weak self] repo, completion in
            self?.container.environment.issueService.requestRepositoryLabels(repo: repo, completion: completion)
        } requestRepositoryMilestones: {
            [weak self] repo, completion in
            self?.container.environment.issueService.requestRepositoryMilestones(repo: repo, completion: completion)
        } requestRepositoryAssigness: {
            [weak self] repo, completion in
            self?.container.environment.issueService.requestRepositoryAssigness(repo: repo, completion: completion)
        }

        let optionSelectModel = OptionSelectModel(environment: optionSelectModelEnvironment)
        let optionSelectVC = OptionSelectViewController(model: optionSelectModel, option: option, repo: repo)
        
        container.register(optionSelectModel)
        container.register(optionSelectVC)
        
        optionSelectVC.delegate = self
        
        navigationController.pushViewController(optionSelectVC, animated: true)
    }
}

extension OptionSelectCoordinator: OptionSelectViewControllerDelegate {
    func selected(item: Optionable, option: Option) {
        self.delegate?.goBackToNewIssueVC(item: item, option: option)
    }
}
