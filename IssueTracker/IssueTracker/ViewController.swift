//
//  ViewController.swift
//  IssueTracker
//
//  Created by Sujin Jin on 2022/06/13.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        requestLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    
    private func requestLogin() {
        if let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(PrivateStorage.clientId)") {
            
            UIApplication.shared.open(url) // 새 사파리 창을 열기
        }
    }
    
}

