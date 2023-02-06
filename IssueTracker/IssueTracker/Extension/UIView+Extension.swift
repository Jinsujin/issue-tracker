import UIKit

extension UICollectionViewCell {
    static var identifier : String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier : String {
        return String(describing: self)
    }
}
