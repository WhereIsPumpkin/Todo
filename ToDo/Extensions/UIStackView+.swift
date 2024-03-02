//
//  UIStackView+.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 02.03.24.
//

import UIKit

extension UIStackView {
    func addTopBorder(withColor color: UIColor, height: CGFloat) {
           // Check if the border layer already exists
           let existingBorder = self.layer.sublayers?.first { $0.name == "topBorder" }
           existingBorder?.removeFromSuperlayer() // Remove it if exists
           
           let border = CALayer()
           border.name = "topBorder"
           border.backgroundColor = color.cgColor
           // Use bounds instead of frame size to correctly get the width
           border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
           self.layer.addSublayer(border)
       }
}
