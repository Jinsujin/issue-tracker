//
//  ViewController.swift
//  IssueTracker
//
//  Created by Sujin Jin on 2022/06/13.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private lazy var loginButton: UIButton = {
        
        var configuration = UIButton.Configuration.gray()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 20)
        configuration.attributedTitle = AttributedString("Github Login", attributes: container)
        
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.black
        configuration.buttonSize = .large
        configuration.image = UIImage(named: "GitHub-Mark")
        configuration.imagePadding = 8
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { _ in
            self.requestLogin()
        }))
        return button
    }()
    
    private func requestLogin() {
        if let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(PrivateStorage.clientId)") {
            
            UIApplication.shared.open(url) // 새 사파리 창을 열기
        }
    }
    
}

