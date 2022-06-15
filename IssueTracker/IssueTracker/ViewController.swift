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
        let button = UIButton(type: .custom, primaryAction: UIAction(handler: { _ in
            self.requestLogin()
        }))
        button.setTitle("Github 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    private func requestLogin() {
        if let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(PrivateStorage.clientId)") {
            
            UIApplication.shared.open(url) // 새 사파리 창을 열기
        }
    }
    
}

