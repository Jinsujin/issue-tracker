import UIKit

extension UIStackView {
    func clearSubviews() {
        arrangedSubviews.forEach { [weak self] view in
            self?.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
