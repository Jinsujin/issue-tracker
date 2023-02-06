import UIKit


final class IssueListCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(title: String, description: String?, milestone: String?, labels: [Label]) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.milestoneLabel.text = milestone
        self.labelsStackView.clearSubviews()
        for label in labels {
            let view = CapsuleTextView(title: label.name, hexColor: label.color)
            labelsStackView.addArrangedSubview(view)
        }
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, milestoneLabel, labelsStackView])
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 24, left: Margins.side, bottom: 24, right: Margins.side))
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .systemGray5
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description"
        label.textColor = .systemGray
        return label
    }()
    
    private let milestoneLabel: UILabel = {
        let label = UILabel()
        label.text = "milestone"
        label.textColor = .systemGray
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
}

