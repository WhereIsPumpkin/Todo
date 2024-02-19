//
//  UITextField+Extensions.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 20.02.24.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UITextField {
    func addLeftImage(_ image: UIImage, padding: CGFloat, tapAction: (() -> Void)?) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        let imageSize = CGSize(width: padding, height: self.frame.size.height)
        imageView.frame = CGRect(origin: .zero, size: imageSize)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        paddingView.addSubview(imageView)
        
        self.leftView = paddingView
        self.leftViewMode = .always
        
        if let action = tapAction {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTapped))
            paddingView.addGestureRecognizer(tapGesture)
            paddingView.isUserInteractionEnabled = true
            objc_setAssociatedObject(self, "tapAction", action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func leftViewTapped() {
        print("Left view tapped") // Check if this line prints
        // Execute the provided tap action (if any)
        if let action = objc_getAssociatedObject(self, "tapAction") as? (() -> Void) {
            print("Action is printed")
            action()
        }
    }
}

