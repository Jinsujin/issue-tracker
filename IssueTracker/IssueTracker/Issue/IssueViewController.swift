import UIKit


protocol IssueViewControllerDelegate: AnyObject {
    func touchedNewIssueButton(repo: Repository)
}

final class IssueViewController: UIViewController {
    
    private let model: IssueModel
    private let repo: Repository
    
    weak var delegate: IssueViewControllerDelegate?
    
    init(model: IssueModel, repo: Repository) {
        self.model = model
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("-- \(type(of: self)) is deinited")
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Issues"
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        
        model.issuesUpdated = {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadIssue() {
        self.model.requestIssue { titleArr in
            if titleArr != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchIssue() {
        self.model.requestIssue { titleArr in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func touchedSelectButton() {
        
    }
    
    @objc func touchedFilterButton() {
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func touchedAddButton() {
        self.delegate?.touchedNewIssueButton(repo: repo)
    }
    
    private func setupNavigationBar() {
        let selectButton = createButton(title: "선택", image: UIImage(systemName: "checkmark.circle"), action: UIAction(handler: { [weak self] _ in
            self?.touchedSelectButton()
        }))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectButton)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { [weak self] make in
            guard let self = self else {
                return
            }
            make.edges.equalTo(self.view)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { [weak self] make in
            guard let self = self else {
                return
            }
            make.bottom.equalTo(self.view).offset(-50)
            make.trailing.equalTo(self.view).offset(-50)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IssueListCell.self, forCellWithReuseIdentifier: IssueListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        configuration.background.cornerRadius = 70
        var button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.touchedAddButton()
        }))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return button
    }()
    
    private func createButton(title: String, image: UIImage?, action: UIAction) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        configuration.buttonSize = .small
        configuration.image = image
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }
    
    private func createButton(title: String, action: UIAction) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }
}


extension IssueViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.getIssuesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueListCell.identifier, for: indexPath) as? IssueListCell,
              let data = model.getIssue(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.updateViews(title: data.title, description: data.body, milestone: data.milestone?.title, labels: data.labels)
        return cell
    }
}

extension IssueViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
