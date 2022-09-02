//
//  NewIssueViewController.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/22.
//

import UIKit

protocol NewIssueViewControllerDelegate: AnyObject {
    func goBackToPreviousVC(repo: Repository)
    
    func touchedOption(option: Option, repo: Repository)
}

class NewIssueViewController: UIViewController {
    
    weak var delegate: NewIssueViewControllerDelegate?
    
    private let model: NewIssueModel
    
    private let optionList = Option.allCases
    private var selectedList = Array<String>(repeating: "", count: Option.allCases.count)
    
    private var selectedLabel: Label?
    private var selectedMilestone: Milestone?
    private var selectedAssignee: Assignee?
    
    private let repo: Repository
    
    init(repo: Repository, model: NewIssueModel) {
        self.repo = repo
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        
        let owner = Owner(login: "")
        let modelEnvironment = NewIssueModelEnvironment { _, _ in
        }
        let model = NewIssueModel(environment: modelEnvironment)
        self.init(repo: Repository(name: "",
                                   owner: owner),
                  model: model)
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var navSegmentedControl: UISegmentedControl = {
        let buttonList = ["마크다운", "미리보기"]
        var control = UISegmentedControl(items: buttonList)
        
        return control
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "제목"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var titleField: UITextField = {
        var textField = UITextField()
        return textField
    }()
    
    private lazy var contentField: UITextView = {
        var contentField = UITextView()
        return contentField
    }()
    
    private lazy var horizontalDevider: UIView = {
        var devider = Devider(direction: .horizontal(width: self.view.bounds.width), color: .systemGray)
        return devider
    }()
    
    private let optionTableCellIdentifier = "optionTableCellIdentifier"
    
    private lazy var optionTable: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: optionTableCellIdentifier)
        return tableView
    }()
    
    private lazy var optionTableHeader: UILabel = {
        var label = UILabel()
        label.text = "추가옵션"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpViews()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func reloadOptions() {
        self.optionTable.reloadData()
    }

    private func setupNavigationBar() {
        self.navigationItem.titleView = navSegmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.width.equalTo(50)
        }
        
        self.view.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.top.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        
        self.view.addSubview(horizontalDevider)
        horizontalDevider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
            make.height.equalTo(1)
        }
        
        optionTable.tableHeaderView = optionTableHeader
        optionTable.tableHeaderView?.frame.size.height = 30
        
        self.view.addSubview(optionTable)
        optionTable.isScrollEnabled = true
        optionTable.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(optionTable
                .contentSize
                .height + 30)
        }
        
        self.view.addSubview(contentField)
        contentField.snp.makeConstraints { make in
            make.top.equalTo(horizontalDevider.snp.bottom)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(optionTable.snp.top)
        }
    }
    
    private lazy var createButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        configuration.attributedTitle = AttributedString("저장", attributes: container)
        
        configuration.buttonSize = .small
        configuration.image = UIImage(systemName: "folder.badge.plus")
        configuration.imagePadding = 4
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { action in
            self.touchedCreateButton()
        }))
        return button
    }()
    
    private func touchedCreateButton() {
        guard let titleString = self.titleField.text,
              !titleString.isEmpty else {
            // TODO: - 타이틀 입력 값이 없다 => 얼럿
            return
        }
        
        guard let contentString = contentField.text else {
            return
        }
        
        let newIssueFormat = NewIssueFormat(title: titleString, repo: repo, content: contentString, label: selectedLabel, milestone: selectedMilestone, assignee: selectedAssignee)
        
        // 모델을 통해 이슈 생성요청을 보낸다
        // 생성되었다면 현재 VC를 없애고 이전 VC로 되돌아간다
        // 되돌아간 VC를 업데이트한다
        model.createIssue(newIssue: newIssueFormat) { [weak self] boolResult in
            if boolResult {
                guard let delegate = self?.delegate,
                      let repo = self?.repo else {
                    return
                }
                delegate.goBackToPreviousVC(repo: repo)
            }
        }
    }
}

extension NewIssueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = optionList[indexPath.row]
        self.delegate?.touchedOption(option: option, repo: repo)
        // 아래 코드들을 delegate 처리
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let viewController = appdelegate.container.buildViewController(.optionSelect(option: option, repo: repo)) as? OptionSelectViewController else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.delegate = self
    }
}

extension NewIssueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionTableCellIdentifier,
                                                 for: indexPath)
        var sidebarCell = UIListContentConfiguration.sidebarCell()
        sidebarCell.text = optionList[indexPath.item].description
        sidebarCell.secondaryText = selectedList[indexPath.item]
        sidebarCell.prefersSideBySideTextAndSecondaryText = true
        
        cell.contentConfiguration = sidebarCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension NewIssueViewController: OptionSelectViewControllerDelegate {
    func selected(item: Optionable, option: Option) {
        guard let optionIndex = optionList.firstIndex(of: option) else {
            return
        }
        
        switch option {
        case .label:
            selectedLabel = item as? Label
        case .milestone:
            selectedMilestone = item as? Milestone
        case .assignee:
            selectedAssignee = item as? Assignee
        }
        
        selectedList[optionIndex] = item.subTitle
        reloadOptions()
    }
}
