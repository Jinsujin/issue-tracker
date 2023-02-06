//
//  AppCoordinator.swift
//  IssueTracker
//
//  Created by Bibi on 2022/08/09.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {
    
    let container = Container(environment: .live)
    
    let navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // navigationController의 동작 감지
        navigationController.delegate = self
        
        showRootViewController()
    }
    
    func fetchToken(url: URL, completion: @escaping (Bool) -> Void) {
        container.fetchAccessToken(url: url) { bool in
            completion(bool)
        }
    }
    
    func showRootViewController() {
        container.environment.githubUserDefaults.getToken() != nil
        ? showReposViewController()
        : showLoginViewController()
    }
    
    private func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: navigationController, container: container)
        coordinator.delegate = self
        container.register(coordinator)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showReposViewController() {
        let coordinator = ReposCoordinator(navigationController: navigationController, container: container)
        coordinator.delegate = self
        container.register(coordinator)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showIssueViewController(repo: Repository) {
        let coordinator = IssueCoordinator(navigationController: navigationController, container: container, repository: repo)
        coordinator.delegate = self
        container.register(coordinator)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showNewIssueViewController(repo: Repository) {
        let coordinator = NewIssueCoordinator(navigationController: navigationController, container: container, repo: repo)
        coordinator.delegate = self
        container.register(coordinator)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func showOptionSelectViewController(option: Option, repo: Repository) {
        let coordinator = OptionSelectCoordinator(navigationController: navigationController, container: container, option: option, repo: repo)
        coordinator.delegate = self
        container.register(coordinator)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child { // 참조 비교
                childCoordinators.remove(at: index)
            }
        }
    }
}

// 아래에 delegate받아 처리할 메서드(화면전환) 로직 작성
extension AppCoordinator: LoginCoordinatorDelegate {
    func didLoggedIn(coordinator: LoginCoordinator) {
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
    }
}

extension AppCoordinator: ReposCoordinatorDelegate {
    func didSelect(repository: Repository) {
        showIssueViewController(repo: repository)
    }
}

extension AppCoordinator: IssueCoordinatorDelegate {
    func makeIssue(with repo: Repository) {
        showNewIssueViewController(repo: repo)
    }
}

extension AppCoordinator: NewIssueCoordinatorDelegate {
    
    func showOptions(option: Option, repo: Repository) {
        showOptionSelectViewController(option: option, repo: repo)
    }
    
    func goBackToIssueVC(repo: Repository) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        guard let issueCoordinator: IssueCoordinator = container.resolve() else {
            return
        }
        issueCoordinator.fetchIssues()
    }
}

extension AppCoordinator: OptionSelectCoordinatorDelegate {
    func goBackToNewIssueVC(item: Optionable, option: Option) {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
        }
        
        guard let newIssueCoordinator: NewIssueCoordinator = container.resolve() else {
            return
        }
        newIssueCoordinator.setOptions(item: item, option: option)
        newIssueCoordinator.reloadOptions()
    }
    
    
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) { // navCon이 새 뷰컨을 보여준 직후 호출되어, 어떤 뷰컨으로부터 이동했는지 확인 가능
        // MARK: 뭐하는 코드인지 공부하기
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // navStack에 존재한다면 - pop이 아닌 push된 것이므로 별도의 처리가 필요하지 않음
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // navStack에 존재하지 않음 = pop됨 : 해당 뷰컨의 coordinator를 childCoordinators에서 지워야 함
        if let coordinator = container.resolvePair(of: fromViewController) {
            removeChildCoordinator(child: coordinator)
        }
    }
}
