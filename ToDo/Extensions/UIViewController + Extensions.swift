//
//  UIViewController + Extensions.swift
//  ToDo
//
//  Created by Saba Gogrichiani on 23.02.24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { alertController.addAction($0) }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
