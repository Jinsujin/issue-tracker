//
//  Devider.swift
//  IssueTracker
//
//  Created by Bibi on 2022/06/22.
//

import UIKit

class Devider: UIView {
    enum Direction {
        case horizontal(width: CGFloat)
        case vertical(height: CGFloat)
    }
    
    convenience init(direction: Devider.Direction, color: UIColor) {
        self.init() // convenience init 사용 시 self.init 먼저 해 주고, override func draw() 해야
        switch direction {
        case .horizontal(let width):
            self.frame = CGRect(origin: .zero,
                                size: CGSize(width: width, height: 5))
            self.backgroundColor = color
        case .vertical(let height):
            self.frame = CGRect(origin: .zero,
                                size: CGSize(width: 5, height: height))
            self.backgroundColor = color
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
