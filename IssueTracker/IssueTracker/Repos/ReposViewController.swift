import UIKit
import SnapKit

protocol ReposViewControllerDelegate: AnyObject {
    func showIssue(didSelectRowAt indexPath: IndexPath)
}

class ReposViewController: UIViewController {
    
    weak var delegate: ReposViewControllerDelegate?
    
    private let model: ReposModel
    private let tableViewCellIdentifier = "tableViewCellIdentifier"
    
    init(model: ReposModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
    }
    
    deinit {
        print("-- \(type(of: self)) is deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        
        model.updated = { [weak self] repos in
            self?.reloadTableView()
        }
        
        model.fetchViewData { [weak self] bool in
            if bool {
                self?.reloadTableView()
            }
        }
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

}

extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showIssue(didSelectRowAt: indexPath)
    }
}

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = model.getViewData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.attributedText = NSAttributedString(string: data.name)
        cell.contentConfiguration = content
        return cell
    }
}
