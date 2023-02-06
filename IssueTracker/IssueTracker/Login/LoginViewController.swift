//
//  LoginViewController.swift
//  IssueTracker
//
//  Created by Sujin Jin on 2022/06/13.
//

import UIKit
import SnapKit
import Alamofire

protocol LoginViewControllerDelegate: AnyObject {
    func login()
}

class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?
    
    private var model: LoginModel
    
    init(model: LoginModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.model = LoginModel(environment: .init(requestCode: { completion in 
        }))
        super.init(coder: coder)
    }
    
    deinit {
        print("-- \(type(of: self)) is deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
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
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.loginButtonTapped()
        }))
        return button
    }()
    
    func loginButtonTapped() {
        model.requestCode { [weak self] result in // TODO: delegate로 옮기기
            switch result {
            case .success(let url):
                UIApplication.shared.open(url)
                self?.delegate?.login()
            case .failure(let error):
                print(error)
            }
        }
    }
}

