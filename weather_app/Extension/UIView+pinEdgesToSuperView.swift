//
//  UIView+pinEdgesToSuperView.swift
//  weathermy
//
//  Created by Rustam Aliyev on 26.06.2023.
//

import Foundation
import UIKit

extension UIView {
    
    func pinEdgesToSuperview(_ distance: CGFloat = 0) {
        
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: distance),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: distance),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: distance),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: distance)
        ])
    }
    
    func pinEdgesToSuperview(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: right)
        ])
    }
}
