import UIKit


final class CapsuleTextView: UIView {
    
    convenience init(title: String, hexColor: String) {
        self.init(frame: .zero)
        self.backgroundColor = UIColor(hexString: "#\(hexColor)")
        titleLabel.text = title
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = rect.height * 0.5
        clipsToBounds = true
    }
    
    func updateView(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        self.snp.makeConstraints { make in
            make.edges.equalTo(titleLabel).inset(UIEdgeInsets(top: -4, left: -6, bottom: -4, right: -6))
        }
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
