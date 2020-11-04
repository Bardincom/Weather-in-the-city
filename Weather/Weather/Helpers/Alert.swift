//
//  Alert.swift
//  Weather
//
//  Created by Aleksey Bardin on 04.11.2020.
//

import UIKit

final class Alert {

    class func showAlert(_ viewController: UIViewController, _ message: String, handler: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: ButtonsName.delete, style: .default, handler: { _ in
                handler()
            }))
            alert.addAction(UIAlertAction(title: ButtonsName.ok, style: .cancel, handler: nil))

            viewController.present(alert, animated: true)
        }
    }
}
