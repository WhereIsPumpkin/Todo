//
//  UILabel+.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 02.03.24.
//

import UIKit

extension UILabel {
    func applyStrikethrough() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
    
    func removeStrikethrough() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 0,
            range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}
